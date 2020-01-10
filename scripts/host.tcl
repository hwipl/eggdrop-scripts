# host.tcl
#
# This script resolves host names or ip addresses using the tool "host" with
# the !host command.
#
# Usage:
#       !host name|ip           resolve name or ip address
#
# Enable for a channel with:    .chanset #channel +host
# Disable for a channel with:   .chanset #channel -host
#
# See https://github.com/hwipl/eggdrop-scripts for the latest version and
# additional information including the license (MIT).

# tested versions, might run on earlier versions
package require Tcl 8.6
package require eggdrop 1.8.4

namespace eval ::host {
	# channel flag for enabling/disabling
	setudef flag host

	# path to host tool
	variable hostCmd "/usr/bin/host"
}

proc ::host::lookup { nick host hand chan arg } {
	variable hostCmd

	# check channel flag if enabled in this channel
	if {![channel get $chan host]} {
		return 0
	}

	# check if hostname/ip parameter is given
	if {$arg == ""} {
		return 0
	}

	# run host and capture output
	if {[catch {exec $hostCmd [lindex $arg 0]} output]} {
		putlog "Error executing $hostCmd: $output"
		return 0
	}

	# send every output line as a message
	foreach i [split $output "\n"] {
		puthelp "PRIVMSG $chan :$i"
	}
	return 1
}

namespace eval ::host {
	bind pub - !host ::host::lookup
	putlog "Loaded host.tcl"
}
