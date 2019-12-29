# topic.tcl

proc set_topic_off { nick host hand chan arg } {
	putserv "TOPIC $chan :Something is now offline"
}

proc set_topic_on { nick host hand chan arg } {
	putserv "TOPIC $chan :Something is now online"
}

proc set_topic { nick host hand chan arg } {
	if [isop $chan $nick] {
	putserv "TOPIC $chan :$arg"
	}
}

bind pub o|o !off set_topic_off
bind pub o|o !on set_topic_on
bind pub - !topic set_topic
