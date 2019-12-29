# host.tcl

proc host_lookup { nick host hand chan arg } {
	set output [exec host [lindex $arg 0]]
	puthelp "PRIVMSG $chan :[lrange $output 0 end]"
}

bind pub - !host host_lookup
