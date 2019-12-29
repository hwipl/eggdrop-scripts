###################################################################
#
# qstat.tcl
#
# CONFIG:
#
# Here you can change some global variables. You can change the
# name and/or path of the file you want to store the servers in
# and its backup file.

set qstat "/path/to/qstat"		;#path to your qstat binary
set optionsall "-u -default q2s"	;#qstat options for all servers
set optionssingle "-P -u -q2s"		;#qstat options for single server

set file "servers.lst"			;#file to store servers in
set filebak "servers.lst.bak"		;#server backup file

# Here you can change the command names to something you like more.

set addcommand "!addserver"		;#add server to the list
set delcommand "!delserver"		;#remove server from list
set showcommand "!serverlist"		;#show servers in list (no qstat)
set refreshcommand "!refresh"		;#show server stats (qstat)

# END OF CONFIG
####################################################################

global file
global filebak
global qstat
global optionsall
global optionssingle

set playerlist1 ""
global playerlist1

# this procedure shows the saved matches:
proc show_matches {nick host hand chan arg} {
	global file
	if {[isop $nick $chan]} {
	if {[file exists $file]} {
	if {[file size $file] > 0} {
	if ![catch {open $file r} input] {
	while {[gets $input line] >= 0} {
		lappend matches $line
	}
	close $input
	puthelp "PRIVMSG $nick :*** Server List ***:"
	for { set i 0 } { $i < [llength $matches] } { incr i } {
	puthelp "PRIVMSG $nick :([expr $i +1])  [lindex $matches $i]"
	}
	} else { puthelp "NOTICE $nick :Error opening file: $input" }
	} else { puthelp "PRIVMSG $nick :No servers have been added yet..."}
	} else { puthelp "PRIVMSG $nick :No servers have been added yet..."}
	}
}

# this procedure deletes saved matches:
proc del_match {nick host hand chan arg} {
	global file
	global filebak
	if {[isop $nick $chan]} {
	if {[file exists $file]} {
	if {[file size $file] > 0} {
	if ![catch {open $file r} input] {
	while {[gets $input line] >= 0} {
		lappend matches $line
	}
	if {$arg <= [llength $matches] && $arg != 0} {
	close $input
	file copy -force $file $filebak
	if ![catch {open $file w} output] {
	for { set i 0 } { $i < [llength $matches] } { incr i } {
	if {[expr $i +1] != $arg} { puts $output "[lindex $matches $i]" }
	}
	close $output
	puthelp "NOTICE $nick :Attempted to delete server number $arg."
	putlog "match.tcl: $nick@$chan attempted to delete server number $arg."
	} else { puthelp "NOTICE $nick :Error opening file: $output"
		 putlog "match.tcl: ERROR! Error opening file: $output"}
	} else { puthelp "NOTICE $nick :Can't delete servers that don't exist..." }
	} else { puthelp "NOTICE $nick :Error opening file: $input"
		 putlog "match.tcl: ERROR! Error opening file: $input"}
	} else { puthelp "NOTICE $nick :Can't delete servers that don't exist..." }
	} else { puthelp "NOTICE $nick :Can't delete servers that don't exist..." }
	}
}

# this procedure adds matches to the list:
proc add_match {nick host hand chan arg} {
	global file
	if {[isop $nick $chan]} {
	if { $arg != "" } {

        set match [regexp {[\d]+.[\d]+.[\d]+.[\d]+:[\d]+} $arg matchl]
	if { $match == 1 } {

	if ![catch {open $file a} output] {
	puts $output "$arg"
	close $output
	puthelp "NOTICE $nick :Attempted to add server."
	putlog "match.tcl: $nick@$chan attempted to add a server to the list"
	} else { puthelp "NOTICE $nick :Error opening file: $output"
		 putlog "match.tcl: ERROR! Error opening file: $output"}
	}
	} else { puthelp "NOTICE $nick :Can't add empty entry" }
	}
}


proc refresh_servers {nick host hand chan arg} {
	global qstat
	global file
	global playerlist1
	global optionsall
	global optionssingle

	if { $arg == "" } {

	if {[file exists $file]} {

	if {[file size $file] > 0} {

	if ![catch {open $file r} input] {
	while {[gets $input line] >= 0} {
	lappend matches $line
	}
	close $input
	}

	if ![catch {open "|$qstat $optionsall -f $file" r} input] {

	while {[gets $input line] >= 0} {
	formatline $line $chan $matches
	}

	close $input
	} else { puthelp "PRIVMSG $nick :Error refreshing servers: $input " }
	} else { puthelp "PRIVMSG $nick :No servers have been added yet..." }
	} else { puthelp "PRIVMSG $nick :No servers have been added yet..." }

	} else {

	set playerlist1 ""
	if {[file exists $file]} {
	if {[file size $file] > 0} {
	if ![catch {open $file r} input] {
	while {[gets $input line] >= 0} {
	lappend matches $line
	}
	close $input
	}
        if ![catch {open "|$qstat $optionssingle [lindex $matches [expr $arg -1]]" r} input] {
	while {[gets $input line] >= 0} {
	formatone $line $chan $arg
	}
	if { $playerlist1 != "" } { puthelp "PRIVMSG $chan :$playerlist1" }
	close $input
	} else { puthelp "NOTICE $nick :Error opening file: $input" }
	} else { puthelp "PRIVMSG $chan :No servers have been added yet..."}
	} else { puthelp "PRIVMSG $chan :No servers have been added yet..."}

	}
}

proc formatline { line chan matches } {
	set match [regexp {([\d]+.[\d]+.[\d]+.[\d]+:[\d]+)\
                   [\s]*([\d]+/[\d]+)[\s]*\
		   ([\w]+)[\s]*([\d]+)[\s]*/[\s]*[\d]+\
		   [\s]*([\w]+)[\s]*(.+)} $line matchln address players map ping type name]
	#puthelp "PRIVMSG $chan :$match"

	if { $match == 1 } {
	set number [expr [lsearch $matches $address] +1]
	puthelp "PRIVMSG $chan :($number) \0030,1\00307[format "%-21s " $address] \00315[format "%-45s " $name] \0034[format "%-7s " ($players)] \00315[format "%-10s " ($map)]"}
}

proc formatone { line chan arg } {
	global playerlist1
        set match [regexp {([\d]+.[\d]+.[\d]+.[\d]+:[\d]+)\
	                   [\s]*([\d]+/[\d]+)[\s]*\
			   ([\w]+)[\s]*([\d]+)[\s]*/[\s]*[\d]+\
			   [\s]*([\w]+)[\s]*(.+)} $line matchln address players map ping type name]
	#puthelp "PRIVMSG $chan :$match"
        if { $match == 1 } {
	puthelp "PRIVMSG $chan :($arg) \0030,1\00307[format "%-21s " $address] \00315[format "%-45s " $name] \0034[format "%-7s " ($players)] \00315[format "%-10s " ($map)]"
	} else {
	set match2 [regexp {[\s]*(-*[\d]+)[\s]*frags[\s]*([\d]+)ms[\s]*(.+)} $line matchln2 playerfrags playerping playername]
		if { $match2 == 1 } {
			if { $playerlist1 != "" } {
			set playerlist1 "${playerlist1}, \00307$playername \00315(${playerfrags} frags, \00304${playerping}ms)"
			} else { set playerlist1 "\0030,1\00307$playername \00315(${playerfrags} frags, \00304${playerping}ms)"
			}
		}
	}
}

# binds to call the procedures:
bind pub - $showcommand show_matches
bind pub - $addcommand add_match
bind pub - $delcommand del_match
bind pub - $refreshcommand refresh_servers
