# beer.tcl
#
# This script gives a beer to people with the !beer command.
#
# Usage:
#       !beer                   give a beer to yourself
#       !beer <user>            give a beer to <user>
#
# Enable for a channel with:    .chanset #channel +beer
# Disable for a channel with:   .chanset #channel -beer
#
# See https://github.com/hwipl/eggdrop-scripts for the latest version and
# additional information including the license (MIT).

# tested versions, might run on earlier versions
package require Tcl 8.6
package require eggdrop 1.8.4

namespace eval ::beer {
	# channel flag for enabling/disabling
	setudef flag beer
}

proc ::beer::give_beer { nick host hand chan arg } {
	# check channel flag if enabled in this channel
	if {![channel get $chan beer]} {
		return 0
	}

	# set receiver
	set receiver $nick
	if { $arg != "" } {
		set receiver [lindex $arg 0]
	}

	puthelp "PRIVMSG $chan :\001ACTION gives $receiver an ice cold beer."
	return 1
}

namespace eval ::beer {
	bind pub - !beer ::beer::give_beer
	putlog "Loaded beer.tcl"
}
