# topic.tcl
#
# This script sets the topic in a channel with the !topic command.
# Additionally, it contains examples of setting a specific topic, e.g., if a
# stream is online/offline with the !on and !off commands.
#
# Usage:
#       !topic topic            set topic in channel to topic
#       !on                     set preconfigured "on" topic in channel
#       !off                    set preconfigured "off" topic in channel
#
# Enable for a channel with:    .chanset #channel +topic
# Disable for a channel with:   .chanset #channel -topic

# tested versions, might run on earlier versions
package require Tcl 8.6
package require eggdrop 1.8.4

namespace eval ::topic {
	# channel flag for enabling/disabling
	setudef flag topic

	# topic for !on command
	variable onTopic "Something is now online."

	# topic for !off command
	variable offTopic "Something is now offline."
}

proc ::topic::setOffTopic { nick host hand chan arg } {
	variable offTopic

	# check channel flag if enabled in this channel
	if {![channel get $chan topic]} {
		return 0
	}

	# set topic
	putserv "TOPIC $chan :$offTopic"
	return 1
}

proc ::topic::setOnTopic { nick host hand chan arg } {
	variable onTopic

	# check channel flag if enabled in this channel
	if {![channel get $chan topic]} {
		return 0
	}

	# set topic
	putserv "TOPIC $chan :$onTopic"
	return 1
}

proc ::topic::setTopic { nick host hand chan arg } {
	# check channel flag if enabled in this channel
	if {![channel get $chan topic]} {
		return 0
	}

	# only allow ops to change topic
	if {![isop $nick $chan]} {
		return 0
	}

	# set topic
	if {$arg == ""} {
		return 0
	}
	putserv "TOPIC $chan :$arg"
	return 1
}

namespace eval ::topic {
	# bind pub o|o !off ::topic::setOffTopic
	# bind pub o|o !on ::topic::setOnTopic
	bind pub - !off ::topic::setOffTopic
	bind pub - !on ::topic::setOnTopic
	bind pub - !topic ::topic::setTopic
}
