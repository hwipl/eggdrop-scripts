# match.tcl
#
# This script was originally created to save clan matches in a file,
# to show all the saved matches and to be able to remove them from
# the file again. But it could be used for storing, showing and
# deleting arbitrary lines of text in a file.
#
# Usage:
#       !addmatch match         add match to the file/list.
#       !showmatch              show the saved matches.
#       !delmatch number        remove match with number (as shown
#                               by !showmatch) from the file/list.
#                               The numbers of remaining matches
#                               might change.
#
# The command names can be changed in the config section below.
#
# Enable for a channel with:    .chanset #channel +match
# Disable for a channel with:   .chanset #channel -match
#
# See https://github.com/hwipl/eggdrop-scripts for the latest version and
# additional information including the license (MIT).

# tested versions, might run on earlier versions
package require Tcl 8.6
package require eggdrop 1.8.4

# Config:
namespace eval ::match {
	# channel flag for enabling/disabling
	setudef flag match

	# Name and/or path of the file you want to store the matches in and its
	# backup file. Channel name will be prepended to file name
	variable filename "matches.lst"
	variable filenamebak "matches.lst.bak"

	# Names of the commands for adding, deleting and showing
	variable addcommand "!addmatch"
	variable delcommand "!delmatch"
	variable showcommand "!showmatch"
}
# End of Config

# this procedure shows the saved matches:
proc ::match::show {nick host hand chan arg} {
	variable filename

	# check channel flag if enabled in this channel
	if {![channel get $chan match]} {
		return 0
	}

	# check if file exists and contains matches
	set mfile ${chan}.${filename}
	set nomatches "No matches found."
	if {![file exists $mfile] || [file size $mfile] == 0} {
		puthelp "PRIVMSG $chan :$nomatches"
		return 0
	}

	# read all matches from file
	if {[catch {open $mfile r} input]} {
		puthelp "PRIVMSG $nick :Error opening file: $input"
		return 0
	}
	while {[gets $input line] >= 0} {
		lappend matches $line
	}
	close $input

	# show each match as a message in the channel
	puthelp "PRIVMSG $chan :*** Match List ***"
	for { set i 0 } { $i < [llength $matches] } { incr i } {
		puthelp "PRIVMSG $chan :([expr $i +1])  [lindex $matches $i]"
	}
	puthelp "PRIVMSG $chan :*** End of Match List ***"
	return 1
}

# this procedure deletes saved matches:
proc ::match::del {nick host hand chan arg} {
	variable filename
	variable filenamebak

	# check channel flag if enabled in this channel
	if {![channel get $chan match]} {
		return 0
	}

	# arg containing the match id must be present
	if {$arg == ""} {
		return 0
	}

	# check if file exists and contains matches
	set mfile ${chan}.${filename}
	set mfilebak ${chan}.${filenamebak}
	set noexist "Match does not exist."
	if {![file exists $mfile] || [file size $mfile] == 0} {
		puthelp "PRIVMSG $nick :$noexist"
		return 0
	}

	# read all matches from file
	if {[catch {open $mfile r} input]} {
		puthelp "PRIVMSG $nick :Error opening file: $input"
		return 0
	}
	while {[gets $input line] >= 0} {
		lappend matches $line
	}
	close $input

	# backup matches file
	file copy -force $mfile $mfilebak

	# write matches back to file
	if {[catch {open $mfile w} output]} {
		putshelp "PRIVMSG $nick :Error opening file: $output"
		return 0
	}
	set deleted 0
	for { set i 0 } { $i < [llength $matches] } { incr i } {
		# omit the match that should be deleted
		if {[expr $i +1] == $arg} {
			set deleted 1
			continue
		}
		puts $output "[lindex $matches $i]"
	}
	close $output

	# send result back to caller
	if {$deleted == 0} {
		puthelp "PRIVMSG $nick :$noexist"
		return 0
	}
	puthelp "NOTICE $nick :Match number $arg deleted."
	return 1
}

# this procedure adds matches to the list:
proc ::match::add {nick host hand chan arg} {
	variable filename

	# check channel flag if enabled in this channel
	if {![channel get $chan match]} {
		return 0
	}

	# arg containing the match must be present
	if {$arg == ""} {
		return 0
	}

	# write match to file
	set mfile ${chan}.${filename}
	if {[catch {open $mfile a} output]} {
		puthelp "PRIVMSG $nick :Error opening file: $output"
		return 0
	}
	puts $output "$nick:  $arg"
	close $output

	puthelp "NOTICE $nick :Match added."
	return 1
}

namespace eval ::match {
	bind pub - $showcommand ::match::show
	bind pub - $addcommand ::match::add
	# bind pub o|o $delcommand ::match::del
	bind pub - $delcommand ::match::del
	putlog "Loaded match.tcl"
}
