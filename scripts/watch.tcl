#!/usr/bin/tclsh

proc watch_nick {nick host hand chan argv} {

	global watch_nick_user
	set watch_nick_user $nick

	# check if there are enough parameters
	if {[llength $argv] < 2} {
		puthelp "PRIVMSG $nick :Usage: !watch <add|del|chk> <nick>"
		#puts "PRIVMSG $nick :Usage: !watch <add|del> <nick>"
		return
	}

	# set some variables
	set command [lindex $argv 0]
	set nick2watch [lindex $argv 1]

	if {$command == "add"} {
		watch_add $nick2watch
	} elseif {$command == "del" } {
		watch_del $nick2watch
	} elseif {$command == "chk" } {
		watch_chk $nick2watch
	}
}

proc watch_add {nick} {

	# file where to save nicks
	set nickdb "watch_nick.db"

	# helper var to check if nick is already saved
	set found 0

	# open file and start reading and comparing saved nicks with submitted one
	if ![catch {open $nickdb r} input] {
		while {[gets $input line] >= 0} {
			if {[string compare -nocase $line $nick] == 0} {
			set found 1
			}
		}
		close $input
	}

	# insert nick into nickdb if it´s not already in it
	if { $found == 0} {
		if ![catch {open $nickdb a} output] {
			puts $output $nick
			close $output
		}
	}
}

proc watch_del {nick} {

	# file where to save nicks
	set nickdb "watch_nick.db"

	# open file and read nicks from it (omit nick that´s about to get deleted)
	if ![catch {open $nickdb r} input] {
		while {[gets $input line] >= 0} {
			if {$line != $nick} {
				lappend nicklist $line
			}
		}
		close $input
	}

	# write nicks to the file again
	if ![catch {open $nickdb w} output] {
		foreach entry $nicklist {
			puts $output $entry
		}
		close $output
	}
}


proc watch_chk {nick2watch} {

	bind RAW - 401 watch_chk_nosuch
	bind RAW - 311 watch_chk_info
	putserv "WHOIS $nick2watch"
}

proc watch_chk_nosuch {var1 var2 var3} {
	global watch_nick_user
	puthelp "PRIVMSG $watch_nick_user :offline $var1 || $var2 || $var3"
	unbind RAW - 401 watch_chk_nosuch
	unbind RAW - 311 watch_chk_info
}

proc watch_chk_info {var1 var2 var3} {
	global watch_nick_user
	puthelp "PRIVMSG $watch_nick_user :online $var1 || $var2 || $var3"
	unbind RAW - 401 watch_chk_nosuch
	unbind RAW - 311 watch_chk_info
}

bind pub - !watch watch_nick
