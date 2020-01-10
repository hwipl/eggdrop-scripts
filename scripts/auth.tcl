# auth.tcl
#
# This script authenticates the bot with an authentication service when it is
# connected to a server. The code and settings below are quite specific to
# QuakeNet's authentication service provided by Q.
#
# Note: the authentication user name and password are stored in this script in
# plain text. This is not very secure. So, be careful and use this script at
# your own risk!
#
# The !register command for registering an account on the authentication
# service is disabled by default. Uncomment the respective bind line below if
# you really need it. Do not forget to comment it out again as soon as you have
# registered the account.
#
# See https://github.com/hwipl/eggdrop-scripts for the latest version and
# additional information including the license (MIT).

# tested versions, might run on earlier versions
package require Tcl 8.6
package require eggdrop 1.8.4

namespace eval ::auth {
	# authentication settings for Q (QuakeNet)
	variable serv "Q@CServe.quakenet.org"
	variable name "YourQAccountName"
	variable pass "YourQAccountPassword"
	variable mail "YourMail@Address.com"
}

# authenticate the bot
proc ::auth::auth { type } {
	global botnick
	variable serv
	variable name
	variable pass

	# authenticate the bot and hide host with +x
	putserv "PRIVMSG $serv :AUTH $name $pass"
	putserv "MODE $botnick :+x"

	putlog "Authenticated $botnick with $name on $serv."
	return 0
}

# register the bot with the authentication service
proc ::auth::register {nick host hand chan arg} {
	global botnick
	variable serv
	variable mail

	# register current bot nick as account name with the mail address
	puthelp "PRIVMSG $nick :Registering $botnick and $mail on $serv."
	puthelp "PRIVMSG $serv :HELLO $mail $mail"

	putlog "Registered $botnick and $mail on $serv."
	return 1
}

namespace eval ::auth {
	# bind pub - !register ::auth::register
	bind evnt - init-server ::auth::auth
	putlog "Loaded auth.tcl"
}
