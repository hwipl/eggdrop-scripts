# auth.tcl

proc auth_auth { type } {
	putserv "PRIVMSG <auth_serv> :auth <name> <password>"
	putserv "MODE <name> :+x"
}

#proc auth_register {nick host hand chan arg} {
#	puthelp "PRIVMSG $nick :trying to register..."
#	puthelp "PRIVMSG <auth_serv>: HELLO <email> <email>"
#}

#proc auth_test {nick host hand chan argv} {
#	puthelp "PRIVMSG $nick :test,1,2,3..."
#}

#bind pub - !register auth_register
bind evnt - init-server auth_auth
#bind pub - !test auth_test

