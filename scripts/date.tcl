# date.tcl

proc show_date { nick host hand chan arg } {
	set date_format "%a %b %d %H:%M:%S %Z %Y"
	puthelp "PRIVMSG $chan :[clock format [clock seconds] -format $date_format]"
}

bind pub - !date show_date
