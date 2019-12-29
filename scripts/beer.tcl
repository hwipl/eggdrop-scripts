# beer.tcl

proc give_beer { nick host hand chan arg } {
	if { $arg == "" } {
	puthelp "PRIVMSG $chan :\001ACTION gives $nick an ice cold beer."
	} else {
	puthelp "PRIVMSG $chan :\001ACTION gives [lindex $arg 0] an ice cold beer."
	}
}

bind pub - !beer give_beer
