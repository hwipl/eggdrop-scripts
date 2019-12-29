#!/usr/bin/tclsh
# funwar script
# have fun ;)


package require sql

# sql stuff:
set funwar_sql_server "server.ip.add.ress"
set funwar_sql_user "username"
set funwar_sql_password "password"
set funwar_sql_dbname_et "name of database"
set funwar_sql_dbname_rtcw "name of database"
set funwar_sql_tblname_et "name of table"
set funwar_sql_tblname_rtcw "name of table"

# where the bot should post funwars automatically:
set funwar_channels_auto "#example #test"

# how often should funwars be posted in the above specified channels?
# bind time - "MIN HOUR DAY MONTH YEAR" funwar_auto
# for example:
# bind time - "20 * * * *" funwar auto
# bind time - "50 * * * *" funwar auto
# (posts at 20 and 50 minutes every hour/day/month/year)

bind time - "20 * * * *" funwar_auto
bind time - "50 * * * *" funwar_auto

# which triggers should be used?
set funwar_trigger_et "!et"
set funwar_trigger_rtcw "!rtcw"
set funwar_trigger_both "!funwars"

# what should the output look like?

set funwar_output_header "*** Funwars: ***"
set funwar_output_header2 "Game: Date/Time: XonX: Clantag: IRC:"
set funwar_output_footer "*** end of funwars list ***"


#<don´t change>
proc funwar_post {game id date time xonx clantag irc www server org chan } {
#</don´t change>
	
set funwar_output_body "$game $date $xonx $clantag $irc"


#<don´t change>
puthelp "PRIVMSG $chan :$funwar_output_body"	
}
#</don´t change>


# you shouldn´t change anything below except your really want to modify something!!!

global funwar_sql_server
global funwar_sql_user
global funwar_sql_passwd
global funwar_sql_dbname_et
global funwar_sql_dbname_rtcw
global funwar_sql_tblname_et
global funwar_sql_tblname_rtcw
global funwar_output_header
global funwar_output_header2
global funwar_output_footer
global funwar_channels_auto



proc funwar_sql_parsedb { server user password dbname tblname order chan game limit command} {

global funwar_output_header
global funwar_output_header2
global funwar_output_footer

set counter "1"

set conn [ sql connect $server $user $password ]
set res [ catch { sql selectdb $conn $dbname } msg ]
if { $res != 0 } {
	puthelp "PRIVMSG $chan :Sorry, could not select the database '$dbname': $msg"
}

set res [ sql query $conn "select id,date,time,xonx,clantag,irc,www,server,org from $tblname order by $order desc" ]
if { $res != 0 } {

if { $command != "noheader" } {
	if { [llength $chan] == 1 } {
	puthelp "PRIVMSG $chan :$funwar_output_header"
	puthelp "PRIVMSG $chan :$funwar_output_header2"
	} else {
	foreach channel $chan {
		puthelp "PRIVMSG $channel :$funwar_output_header"
		puthelp "PRIVMSG $channel :$funwar_output_header2"
	}
	}
}

while { [ set row [ sql fetchrow $conn ] ] != "" } {
	set id [lindex $row 0]
	set date [lindex $row 1]
	set time [lindex $row 2]
	set xonx [lindex $row 3]
	set clantag [lindex $row 4]
	set irc [lindex $row 5]
	set www [lindex $row 6]
	set server [lindex $row 7]
	set org [lindex $row 8]

	if { $counter <= $limit } {
	if { [llength $chan] == 1 } {
		funwar_post $game $id $date $time $xonx $clantag $irc $www $server $org $chan
	} else {
		foreach channel $chan {
		funwar_post $game $id $date $time $xonx $clantag $irc $www $server $org $channel
		}
	}
	}
	incr counter
}

if { $command != "nofooter" } {
if { [llength $chan] == 1 } {
	puthelp "PRIVMSG $chan :$funwar_output_footer"
} else {
	foreach channel $chan {
		puthelp "PRIVMSG $channel :$funwar_output_footer"
	}
}
}

}
sql endquery $conn
sql disconnect $conn


}


proc funwar_rtcw { nick host hand chan arg } {

	global funwar_sql_server
	global funwar_sql_user
	global funwar_sql_password
	global funwar_sql_dbname_rtcw
	global funwar_sql_tblname_rtcw
	
	set order "id"
	set game "RTCW"
	set limit "10"
	set command ""
	
	funwar_sql_parsedb $funwar_sql_server $funwar_sql_user $funwar_sql_password $funwar_sql_dbname_rtcw $funwar_sql_tblname_rtcw $order $chan $game $limit $command

}

proc funwar_et { nick host hand chan arg } {

	global funwar_sql_server
	global funwar_sql_user
	global funwar_sql_password
	global funwar_sql_dbname_et
	global funwar_sql_tblname_et
	
	set order "id"
	set game "ET"
	set limit "10"
	set command ""
	
	funwar_sql_parsedb $funwar_sql_server $funwar_sql_user $funwar_sql_password $funwar_sql_dbname_et $funwar_sql_tblname_et $order $chan $game $limit $command
	
}

proc funwar_both { nick host hand chan arg } {

	global funwar_sql_server
	global funwar_sql_user
	global funwar_sql_password
	global funwar_sql_dbname_rtcw
	global funwar_sql_tblname_rtcw
	global funwar_sql_dbname_et
	global funwar_sql_tblname_et
	
	set order "id"
	set game "RTCW"
	set limit "3"
	set command "nofooter"
	
	funwar_sql_parsedb $funwar_sql_server $funwar_sql_user $funwar_sql_password $funwar_sql_dbname_rtcw $funwar_sql_tblname_rtcw $order $chan $game $limit $command
	
	set game "ET"
	set command "noheader"
	
	funwar_sql_parsedb $funwar_sql_server $funwar_sql_user $funwar_sql_password $funwar_sql_dbname_et $funwar_sql_tblname_et $order $chan $game $limit $command
	
}

proc funwar_auto { min hour day month year } {
	
	global funwar_channels_auto
	global funwar_sql_server
	global funwar_sql_user
	global funwar_sql_password
	global funwar_sql_dbname_rtcw
	global funwar_sql_tblname_rtcw
	global funwar_sql_dbname_et
	global funwar_sql_tblname_et
	global funwar_channels_auto
	
	set order "id"
	set game "RTCW"
	set limit "3"
	set command "nofooter"
	
	funwar_sql_parsedb $funwar_sql_server $funwar_sql_user $funwar_sql_password $funwar_sql_dbname_rtcw $funwar_sql_tblname_rtcw $order $funwar_channels_auto $game $limit $command
	
	set game "ET"
	set command "noheader"
	
	funwar_sql_parsedb $funwar_sql_server $funwar_sql_user $funwar_sql_password $funwar_sql_dbname_et $funwar_sql_tblname_et $order $funwar_channels_auto $game $limit $command
	
}


bind pub - $funwar_trigger_et funwar_et
bind pub - $funwar_trigger_rtcw funwar_rtcw
bind pub - $funwar_trigger_both funwar_both

putlog "Loaded funwars.tcl"
