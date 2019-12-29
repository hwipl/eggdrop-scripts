###################################################################
#
# match.tcl
#
# This script was originally created to save clan matches in a file,
# to show all the saved matches and to be able to remove them from
# the file again.
#
# HOW TO USE THIS SCRIPT:
#
# !add_match      is used to add matches to the file/list.
# !show_matches   is used to show the saved matches.
# !del_match      is used to remove a match from the file/list.
#                 You have to use the match number as an argument.
#                 If you delte a match and there are more matches
#                 after it in the list, all the remaining matches'
#                 numbers will be decreased by 1.
#
# Of course, all those commands can be changed in the config
# section below.
#
# CONFIG:
#
# Here you can change some global variables. You can change the
# name and/or path of the file you want to store the matches in
# and its backup file.

set match_filename "matches.lst" ;#channel name will be appended to file
set match_filenamebak "matches.lst.bak"
set match_channels "#example #test" ;#USE LOWER CASE!
# Here you can change the command names to something you like more.

set match_addcommand "!addmatch"
set match_delcommand "!delmatch"
set match_showcommand "!searchmatch"

# END OF CONFIG
####################################################################

global match_filename
global match_filenamebak
global match_channels

# this procedure shows the saved matches:
proc show_matches {nick host hand chan arg} {
	global match_filename
	global match_channels
	if { [lsearch $match_channels [string tolower $chan]] != -1 } {
	set file ${chan}.${match_filename}
	if {[file exists $file]} {
	if {[file size $file] > 0} {
	if ![catch {open $file r} input] {
	while {[gets $input line] >= 0} {
		lappend matches $line
	}
	close $input
	putserv "PRIVMSG $chan :*** MatchList ***"
	for { set i 0 } { $i < [llength $matches] } { incr i } {
	putserv "PRIVMSG $chan :([expr $i +1])  [lindex $matches $i]"
#	putlog "match.tcl: $nick@$chan attempted to view match list"
	}
	putserv "PRIVMSG $chan :*** End of MatchList ***"
	} else { putserv "PRIVMSG $nick :Error opening file: $input" }
	} else { putserv "PRIVMSG $chan :No matches have been added yet..."}
	} else { putserv "PRIVMSG $chan :No matches have been added yet..."}
	}
}

# this procedure deletes saved matches:
proc del_match {nick host hand chan arg} {
	global match_filename
	global match_filenamebak
	global match_channels
	if { [lsearch $match_channels [string tolower $chan]] != -1 } {
	set file ${chan}.${match_filename}
	set filebak ${chan}.${match_filenamebak}
	if {[file exists $file]} {
	if {[file size $file] > 0} {
	if ![catch {open $file r} input] {
	while {[gets $input line] >= 0} {
		lappend matches $line
	}
	close $input
	file copy -force $file $filebak
	if ![catch {open $file w} output] {
	for { set i 0 } { $i < [llength $matches] } { incr i } {
	if {[expr $i +1] != $arg} { puts $output "[lindex $matches $i]" }
	}
	close $output
	putserv "NOTICE $nick :Match number $arg is now deleted."
	putlog "match.tcl: $nick@$chan attempted to delete match number $arg."
	} else { putserv "PRIVMSG $nick :Error opening file: $input" }
	} else { putserv "PRIVMSG $nick :Error opening file: $input" }
	} else { putserv "PRIVMSG $nick :Can't delete matches that don't exist..." }
	} else { putserv "PRIVMSG $nick :Can't delete matches that don't exist..." }
	}
}

# this procedure adds matches to the list:
proc add_match {nick host hand chan arg} {
	global match_filename
	global match_channels
	if { [lsearch $match_channels [string tolower $chan]] != -1 } {
	set file ${chan}.${match_filename}
	if ![catch {open $file a} output] {
	puts $output "$nick:  $arg"
	close $output
	putserv "NOTICE $nick :Congrats, your Match has been added."
	putlog "match.tcl: $nick@$chan attempted to add a match to the list"
	} else { putserv "PRIVMSG $nick :Error opening file: $input" }
	}
}

# binds to call the procedures:
bind pub - $match_showcommand show_matches
bind pub - $match_addcommand add_match
bind pub o|o $match_delcommand del_match
