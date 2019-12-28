#!/usr/bin/tcl
#
# insult script, connects to insulthost.colorado.edu:1695
# and gets an insult
#
#
# set hostname or IP and port:
proc pub_insult { nick host hand chan arg } {

set insulthost "insulthost.colorado.edu"
set insultport "1695"
set insultnick [lindex $arg 0]

# open socket, get insult message, close socket and
# output the message::

set s [socket -async $insulthost $insultport]
set insult [gets $s]
puthelp "PRIVMSG $chan :$insultnick: $insult"
#after 500
close $s

}

bind pub - !insult pub_insult
