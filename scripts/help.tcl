# help.tcl
#
# This script shows a help text with the !help command.
#
# Usage:
#       !help                   show help text
#
# Enable for a channel with:    .chanset #channel +help
# Disable for a channel with:   .chanset #channel -help

# tested versions, might run on earlier versions
package require Tcl 8.6
package require eggdrop 1.8.4

namespace eval ::help {
	# channel flag for enabling/disabling
	setudef flag help

	# help text
	variable helpText {
		"*** command help: ***"
		" Quake2 Server List Commands:"
		"  !addserver ip:port  - add server with ip:port to list"
		"  !delserver number   - remove server with number from list"
		"  !serverlist         - show servers in list"
		"  !refresh            - refresh servers in list"
		"  !refresh number     - refresh server with number in list"
		" Others:"
		"  !help               - show this help"
		"  !insult user        - insult user with random insult"
		"*** end of help ***"
	}
}

proc ::help::show { nick host hand chan arg } {
	variable helpText

	# check channel flag if enabled in this channel
	if {![channel get $chan help]} {
		return 0
	}

	# send each line of help text as a message
	foreach i $helpText {
		puthelp "PRIVMSG $nick :$i"
	}

	return 1
}

namespace eval ::help {
	bind pub - !help ::help::show
}
