# date.tcl
#
# This script shows the current date and time with the !date command.
#
# Usage:
#       !date                   show the current date and time
#
# Enable for a channel with:    .chanset #channel +date
# Disable for a channel with:   .chanset #channel -date

# tested versions, might run on earlier versions
package require Tcl 8.6
package require eggdrop 1.8.4

namespace eval ::date {
	# channel flag for enabling/disabling
	setudef flag date
}

proc ::date::show_date { nick host hand chan arg } {
	# check channel flag if enabled in this channel
	if {![channel get $chan date]} {
		return 0
	}

	# get current date
	set date_format "%a %b %d %H:%M:%S %Z %Y"
	set date [clock format [clock seconds] -format $date_format]

	puthelp "PRIVMSG $chan :$date"
	return 1
}

namespace eval ::date {
	bind pub - !date ::date::show_date
	putlog "Loaded date.tcl"
}
