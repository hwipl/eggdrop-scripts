# qstat.tcl
#
# This script stores game servers in a server list file and queries their
# status with the utility "qstat" with the server commands below.
#
# Usage:
#       !addserver server       add server to server list
#       !delserver server       remove server from server list
#       !serverlist             show servers in server list
#       !refresh                query status of servers in server list
#
# Enable for a channel with:    .chanset #channel +qstat
# Disable for a channel with:   .chanset #channel -qstat

# tested versions, might run on earlier versions
package require Tcl 8.6
package require eggdrop 1.8.4

namespace eval ::qstat {
	# channel flag for enabling/disabling
	setudef flag qstat

	# command names
	variable addcommand "!addserver"
	variable delcommand "!delserver"
	variable showcommand "!serverlist"
	variable refreshcommand "!refresh"

	# path to your qstat binary
	variable qstat "/usr/local/bin/qstat"

	# qstat options for querying all servers
	variable optionsall "-nh -u -default q2s"

	# qstat options for querying single server
	variable optionssingle "-nh -P -sort F -u -q2s"

	# file to store servers in and its backup file
	variable file "servers.lst"
	variable filebak "servers.lst.bak"
}

# read server list from server file
proc ::qstat::fileGet {} {
	variable file

	# check is server list entries exist
	if {![file exists $file] || [file size $file] == 0} {
		return ""
	}

	# read servers from server file
	set servers ""
	if {[catch {open $file r} input]} {
		return ""
	}
	while {[gets $input line] >= 0} {
		lappend servers $line
	}
	close $input

	return $servers
}

# this procedure shows the saved servers:
proc ::qstat::showServers {nick host hand chan arg} {
	# check channel flag if enabled in this channel
	if {![channel get $chan qstat]} {
		return 0
	}

	# nick must be op
	if {![isop $nick $chan]} {
		return 0
	}

	# read servers from server file
	set servers [fileGet]
	if {$servers == ""} {
		puthelp "PRIVMSG $nick :No servers in server list."
		return 0
	}

	# send each server as a separate message
	puthelp "PRIVMSG $nick :*** Server List ***:"
	set i 1
	foreach s $servers {
		puthelp "PRIVMSG $nick :($i)  $s"
		incr i
	}

	return 1
}

# this procedure deletes saved servers:
proc ::qstat::delServer {nick host hand chan arg} {
	variable file
	variable filebak

	# check channel flag if enabled in this channel
	if {![channel get $chan qstat]} {
		return 0
	}

	# nick must be op
	if {![isop $nick $chan]} {
		return 0
	}

	# read servers from server file
	set servers [fileGet]

	# check if argument contains a valid server number
	if {$arg == "" || $arg > [llength $servers] || $arg == 0} {
		puthelp "NOTICE $nick :Invalid server number."
		return 0
	}

	# backup server file
	file copy -force $file $filebak

	# write servers to server file, omitting deleted server
	if {[catch {open $file w} output]} {
		puthelp "NOTICE $nick :Error opening file: $output"
		putlog "match.tcl: ERROR! Error opening file: $output"
		return 0
	}
	set i 1
	foreach s $servers {
		if {$i != $arg} {
			puts $output $s
		}
		incr i
	}
	close $output

	puthelp "NOTICE $nick :Attempted to delete server number $arg."
	putlog "match.tcl: $nick@$chan attempted to delete server number $arg."
	return 1
}

# this procedure adds matches to the list:
proc ::qstat::addServer {nick host hand chan arg} {
	variable file

	# check channel flag if enabled in this channel
	if {![channel get $chan qstat]} {
		return 0
	}

	# nick must be op
	if {![isop $nick $chan]} {
		return 0
	}

	# check if arg contains valid ip and port
	if { $arg == "" } {
		puthelp "NOTICE $nick :Can't add empty entry"
		return 0
	}
	# NOTE: this only checks ipv4 addresses
        set match [regexp {[\d]+.[\d]+.[\d]+.[\d]+:[\d]+} $arg matchl]
	if { $match != 1 } {
		return 0
	}

	# append server to server file
	if {[catch {open $file a} output]} {
		puthelp "NOTICE $nick :Error opening file: $output"
		putlog "match.tcl: ERROR! Error opening file: $output"
		return 0
	}
	puts $output "$arg"
	close $output

	puthelp "NOTICE $nick :Attempted to add server."
	putlog "match.tcl: $nick@$chan attempted to add a server to the list"
	return 1
}

# format a server info line
proc ::qstat::formatServerLine {line servers} {
	# check if line is a server line and parse it
	set pattern {(?x)
		# server address + whitespace
		([\d]+.[\d]+.[\d]+.[\d]+:[\d]+)[\s]+
		# players cur/max + whitespace
		([\d]+/[\d]+)[\s]+
		# spectators cur/max + whitespace
		([\d]+/[\d]+)[\s]+
		# map + whitespace
		([\w]+)[\s]+
		# ping, retries + whitespace
		([\d]+)[\s]*/[\s]*[\d]+[\s]+
		# server name
		(.+)
	}
	if {[regexp $pattern $line matchln address players spectators \
		map ping name] != 1} {
		return ""
	}

	# format the output
	set number [expr {[lsearch $servers $address] +1}]
	set fmt "%s \0030,1\00307%-21s \00315%-45s \0034%-7s \00315%-10s"
	return [format $fmt ($number) $address $name ($players) ($map)]
}

# format a player info line
proc ::qstat::formatPlayerLine {line} {
	# check if line is a player line and parse it
	set pattern {(?x)
		# frags
		[\s]*(-*[\d]+)[\s]*frags
		# ping
		[\s]*([\d]+)ms
		# player name
		[\s]*(.+)
	}
	if {[regexp $pattern $line matchln playerfrags playerping \
		playername] != 1} {
		return ""
	}

	# format the output
	set p "\0030,1\00307$playername \00315(${playerfrags} frags, "
	set p "$p\00304${playerping}ms)"
	return $p
}


# query all servers in server list with qstat
proc ::qstat::refreshAll {nick chan servers} {
	variable file
	variable qstat
	variable optionsall

	# run qstat and parse output
	if {[catch {open "|$qstat $optionsall -f $file" r} input]} {
		puthelp "PRIVMSG $nick :Error refreshing servers: $input"
		return 0
	}
	while {[gets $input line] >= 0} {
		# show each server line in the channel
		set result [formatServerLine $line $servers]
		if {$result != ""} {
			puthelp "PRIVMSG $chan :$result"
		}
	}
	close $input
}

# query a single server with qstat
proc ::qstat::refreshSingle {nick chan servers server} {
	variable qstat
	variable optionssingle

	# run qstat and parse output
	set playerlist ""
        if {[catch {open "|$qstat $optionssingle $server" r} input]} {
		puthelp "NOTICE $nick :Error refreshing server: $input"
		return 0
	}
	while {[gets $input line] >= 0} {
		# show each server line in the channel
		set result [formatServerLine $line $servers]
		if {$result != ""} {
			puthelp "PRIVMSG $chan :$result"
		}

		# look for players and add them to player list
		set result [formatPlayerLine $line]
		if {$result != ""} {
			lappend playerlist $result
		}
	}
	close $input

	# show the player list in the channel
	if {$playerlist != ""} {
		set players [join $playerlist ", "]
		puthelp "PRIVMSG $chan :$players"
	}
}

# query servers with qstat
proc ::qstat::refreshServers {nick host hand chan arg} {
	# check channel flag if enabled in this channel
	if {![channel get $chan qstat]} {
		return 0
	}

	# read servers from server file
	set servers [fileGet]
	if {$servers == ""} {
		puthelp "PRIVMSG $nick :No servers in server list."
		return 0
	}

	if {$arg == ""} {
		# no extra parameters, refresh all servers
		refreshAll $nick $chan $servers
	} else {
		# only refresh server specified in arg
		set server [lindex $servers [expr {$arg -1}]]
		if {$server == ""} {
			puthelp "PRIVMSG $nick :Server not found."
			return 0
		}
		refreshSingle $nick $chan $servers $server
	}
}

namespace eval ::qstat {
	bind pub - $showcommand ::qstat::showServers
	bind pub - $addcommand ::qstat::addServer
	bind pub - $delcommand ::qstat::delServer
	bind pub - $refreshcommand ::qstat::refreshServers
}
