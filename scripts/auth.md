# auth.tcl

The script [auth.tcl](auth.tcl) authenticates the bot with an authentication
service when it has connected to the IRC server. The code and settings in this
script are quite specific to the authentication service of
[QuakeNet](https://www.quakenet.org) provided by Q.

Note: the authentication user name and password are stored in this script in
plain text. This is not very secure. So, be careful and use this script at
your own risk!

## Setup

You need to configure the authentication service, your username, your password
and your email address inside the script. You can set these in the variables in
the following section that you can find at the top of the script:

```tcl
namespace eval ::auth {
	# authentication settings for Q (QuakeNet)
	variable serv "Q@CServe.quakenet.org"
	variable name "YourQAccountName"
	variable pass "YourQAccountPassword"
	variable mail "YourMail@Address.com"
}
```

## Usage

There are no additional commands required to use this script. After enabling
the script in the Eggdrop configuration file, the script automatically runs its
authentication procedure each time it has established a connection to an IRC
server.

The script contains a `!register` command that can be used to register an
account on the authentication service. It is disabled by default. Uncomment the
respective bind line in the script if you really need it. Do not forget to
comment it out again as soon as you have registered the account.
