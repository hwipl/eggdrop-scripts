# date.tcl
#set date "/usr/bin/date"

#global date

#proc show_date { nick host hand chan arg } {
#	puthelp "PRIVMSG $chan :[clock format [clock seconds]]"
#}
#bind pub - !date show_date


proc show_date { nick host hand chan arg } {
	set date_format "%a %b %d %H:%M:%S %Z %Y"
	puthelp "PRIVMSG $chan :[clock format [clock seconds] -format $date_format]"
}
bind pub - !date show_date
