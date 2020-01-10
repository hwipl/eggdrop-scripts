# watch.tcl
#
# This script watches users with the !watch command and informs the caller when
# the user gets online or offline.
#
# Usage:
#       !watch add user         watch user's status
#       !watch del user         stop watching user's status
#       !watch check user       check user's status once
#
# Enable for a channel with:    .chanset #channel +watch
# Disable for a channel with:   .chanset #channel -watch
#
# See https://github.com/hwipl/eggdrop-scripts for the latest version and
# additional information including the license (MIT).

# tested versions, might run on earlier versions
package require Tcl 8.6
package require eggdrop 1.8.4

namespace eval ::watch {
	# channel flag for enabling/disabling
	setudef flag watch

	# name of file for watched nicks
	variable whoisFile "watchnick.db"

	# list of pending whois requests
	variable whoisList {}
}

# handle !watch command and call subcommands
proc ::watch::watchNick {nick host hand chan argv} {
	set usage "Usage: !watch <add|del|check> <nick>"

	# check channel flag if enabled in this channel
	if {![channel get $chan watch]} {
		return 0
	}

	# check if there are enough parameters
	if {[llength $argv] < 2} {
		puthelp "PRIVMSG $nick :$usage"
		return 0
	}

	# parse arguments and run command
	set command [lindex $argv 0]
	set whoisNick [lindex $argv 1]
	switch $command {
		"add" {
			add $chan $nick $whoisNick
			check $nick $whoisNick
		}
		"del" {
			del $nick $whoisNick
		}
		"check" {
			# set last status to "unknown" so reply is not filtered
			lastStatus $nick $whoisNick "unknown"
			check $nick $whoisNick
		}
		default {
			puthelp "PRIVMSG $nick :$usage"
		}
	}
	return 1
}


# check if entry a in whois file matches entry b
proc ::watch::fileMatch {a b} {
	# only check first two columns, ignore rest
	if {[string compare -nocase [lindex $a 0] [lindex $b 0]] != 0} {
		return 1
	}
	if {[string compare -nocase [lindex $a 1] [lindex $b 1]] != 0} {
		return 1
	}
	return 0
}

# get all entries from whois file
proc ::watch::fileGet {} {
	variable whoisFile

	# read entries from whois file
	set entlist ""
	if {![catch {open $whoisFile r} input]} {
		while {[gets $input line] >= 0} {
			lappend entlist $line
		}
		close $input
	}

	return $entlist
}

# write all entries from entlist to whois file
proc ::watch::filePut {entlist} {
	variable whoisFile

	if {![catch {open $whoisFile w} output]} {
		foreach e $entlist {
			puts $output $e
		}
		close $output
	}
}

# handle !watch subcommand "add"
proc ::watch::add {chan nick whoisNick} {
	variable whoisFile

	# watch entry being added
	set ent "$nick $whoisNick unknown"

	# check if entry already exists
	foreach line [fileGet] {
		if {[fileMatch $line $ent] == 0} {
			# user already being watched
			return 0
		}
	}

	# new watch entry, insert nick into nickdb
	if {![catch {open $whoisFile a} output]} {
		puts $output $ent
		close $output
	}
}

# handle !watch subcommand "del"
proc ::watch::del {nick whoisNick} {
	# watch entry being deleted
	set ent "$nick $whoisNick"

	# find entry in whois file that's about to get deleted
	set entlist [fileGet]
	set i 0
	foreach line $entlist {
		if {[fileMatch $line $ent] == 0} {
			# delete entry and write everything back to whois file
			filePut [lreplace $entlist $i $i]
			return
		}
		incr i
	}
}

# update last status with newStatus and return old status
proc ::watch::lastStatus {nick whoisNick newStatus} {
	# get old status from file and remember line number
	set entlist [fileGet]
	set ent "$nick $whoisNick"
	set last ""
	set i 0
	foreach line $entlist {
		if {[fileMatch $line $ent] == 0} {
			set last [lindex $line 2]
			break
		}
		incr i
	}

	# if there was no entry in the file, stop and return an invalid status
	if {$last == ""} {
		return "none"
	}

	# update last status in file
	set entlist [lreplace $entlist $i $i "$nick $whoisNick $newStatus"]
	filePut $entlist

	# return last status
	return $last
}

# register for whois return codes
proc ::watch::bindWhois {} {
	# 401 - No Such User (offline)
	# 311 - User Info (online)
	bind RAW - 401 ::watch::checkReply
	bind RAW - 311 ::watch::checkReply
}


# unregister whois return codes if no whois is pending
proc ::watch::unbindWhois {} {
	variable whoisList

	# if no whois is pending any more, remove binds
	if {[llength $whoisList] == 0} {
		# 401 - No Such User (offline)
		# 311 - User Info (online)
		unbind RAW - 401 ::watch::checkReply
		unbind RAW - 311 ::watch::checkReply
	}
}

# add entry with nick and whoisNick to whois list
proc ::watch::addWhois {nick whoisNick} {
	variable whoisList

	lappend whoisList "$nick $whoisNick"
}

# remove entry with nick and whoisNick from whois list
proc ::watch::delWhois {nick whoisNick} {
	variable whoisList

	set i [lsearch $whoisList "$nick $whoisNick"]
	set whoisList [lreplace $whoisList $i $i]
}

# find name of user who issued the whois for whoisNick
proc ::watch::findWhois {whoisNick} {
	variable whoisList

	set nick ""
	foreach e $whoisList {
		if {$whoisNick == [lindex $e 1]} {
			set nick [lindex $e 0]
			break
		}
	}

	return $nick
}

# handle !watch subcommand "check"
proc ::watch::check {nick whoisNick} {
	variable whoisList

	# register events
	bindWhois

	# add entry to whois list
	addWhois $nick $whoisNick

	# whois user
	putserv "WHOIS $whoisNick"

	return 1
}

# handle server replies of whois commands
proc ::watch::checkReply {from keyword txt} {
	variable whoisList
	set whoisNick [lindex [split $txt] 1]

	# set state according to reply keyword
	set state "offline"
	if {$keyword == 311} {
		set state "online"
	}

	# find entry in whois list
	set nick [findWhois $whoisNick]
	if {$nick == ""} {
		putlog "Error finding entry in whoisList."
		return 0
	}

	# remove entry from whois list
	delWhois $nick $whoisNick
	unbindWhois

	# update and get last status of watched user
	set last [lastStatus $nick $whoisNick $state]
	if {$last == $state} {
		return 0
	}

	puthelp "PRIVMSG $nick :$whoisNick is $state."
	return 0
}

# periodically check watched nicks
proc ::watch::periodic {minute hour day month weekday} {
	# check each entry in whois file
	set entlist [fileGet]
	foreach e $entlist {
		set nick [lindex $e 0]
		set whoisNick [lindex $e 1]
		check $nick $whoisNick
	}
}

namespace eval ::watch {
	bind pub - !watch ::watch::watchNick
	bind cron - "*/1 * * * *" ::watch::periodic
	putlog "Loaded watch.tcl"
}
