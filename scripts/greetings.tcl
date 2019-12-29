# greetings tcl

proc join_greeting { nick host hand chan } {
	set $greetInChannel ""
	if { [lsearch $greetInChannel $chan] != "-1" } {
	puthelp "NOTICE $nick :Hi ${nick}!"
	}
}

bind join - * join_greeting
