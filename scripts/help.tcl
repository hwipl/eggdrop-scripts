# help.tcl

proc show_help { nick host hand chan arg } {
	putserv "PRIVMSG $nick :*** command help: ***"
	putserv "PRIVMSG $nick : Quake2 Server List Commands:"
	putserv "PRIVMSG $nick :  !addserver ip:port  -   this adds a server to the server list"
	putserv "PRIVMSG $nick :  !delserver number   -   this removes the server specified by number from the server list"
	putserv "PRIVMSG $nick :  !serverlist         -   this shows all servers in the server list"
	putserv "PRIVMSG $nick :  !refresh            -   this refreshes all servers in the server list"
	putserv "PRIVMSG $nick :  !refresh number     -   this refreshes the server specified by number"
	putserv "PRIVMSG $nick : Others:"
	putserv "PRIVMSG $nick :  !help               -   you are viewing this right now ;)"
	putserv "PRIVMSG $nick :  !insult name        -   this insults the user specified by name with a random insult"
	putserv "PRIVMSG $nick :*** end of help ***"
}

bind pub - !help show_help
