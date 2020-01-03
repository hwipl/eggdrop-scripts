# funwar.tcl
#
# This script was created to post fun clan wars/matches for the two multiplayer
# games RTCW and ET in channels periodically and with the commands below. The
# matches are retrieved from tables in postreSQL databases.
#
# Usage:
#       !et                     post ET matches
#       !rtcw                   post RTCW matches
#       !funwars                post ET and RTCW matches
#
# Enable for a channel with:    .chanset #channel +funwar
# Disable for a channel with:   .chanset #channel -funwar

# tested versions, might run on earlier versions
package require Tcl 8.6
package require eggdrop 1.8.4

# postgres sql
package require tdbc::postgres

namespace eval ::funwar {
	# channel flag for enabling/disabling
	setudef flag funwar

	# sql server settings:
	variable sqlServer "server.ip.add.ress"
	variable sqlUser "username"
	variable sqlPassword "password"

	# ET database and table on sql server
	variable sqlDbnameEt "name of database"
	variable sqlTblnameEt "name of table"

	# RTCW database and table on sql server
	variable sqlDbnameRtcw "name of database"
	variable sqlTblnameRtcw "name of table"

	# crontab style definition of how often funwars are posted in channels
	# format:
	#       "MIN HOUR DAY MONTH YEAR"
	# examples:
	#       "20,50 * * * *"         post at minute 20 and 50 of every hour
	#       "*/10 * * * *"          post every ten minutes
	variable autoCron "20,50 * * * *"

	# trigger configuration for ET, RTCW and both
	variable triggerEt "!et"
	variable triggerRtcw "!rtcw"
	variable triggerBoth "!funwars"

	# output configuration
	variable outputHeader "*** Funwars: ***"
	variable outputHeader2 "Game: Date/Time: XonX: Clantag: IRC:"
	variable outputFooter "*** end of funwars list ***"
}

# post the funwar header in the channel
proc ::funwar::postHeader {chan} {
	variable outputHeader
	variable outputHeader2
	set fmt "%-7s %-20s %-6s %-12s %-12s"
	set lineHeader [format $fmt {*}$outputHeader2]

	puthelp "PRIVMSG $chan :$outputHeader"
	puthelp "PRIVMSG $chan :$lineHeader"
}

# post a funwar line in the channel
proc ::funwar::post {game id date time xonx clantag irc www server org chan } {
	set fmt "%-7s %-20s %-6s %-12s %-12s"
	set outputBody [format $fmt $game $date/$time $xonx $clantag $irc]

	puthelp "PRIVMSG $chan :$outputBody"
}

# post the funwar footer in the channel
proc ::funwar::postFooter {chan} {
	variable outputFooter

	puthelp "PRIVMSG $chan :$outputFooter"
}

# get rows from sql table
proc ::funwar::sqlGet {server user password dbname tblname order limit} {
	# connect to data base
	# add -sslmode require if you want to enforce ssl
	tdbc::postgres::connection create db -host $server -database $dbname \
		-user $user -password $password

	# query table in data base
	set columns "id,date,time,xonx,clantag,irc,www,server,org"
	set top "FETCH FIRST $limit ROWS ONLY"
	set queryStr "SELECT $columns FROM $tblname ORDER BY $order DESC $top"
	set query [db prepare $queryStr]

	# collect all rows and return them
	set rows ""
	$query foreach row {
		lappend rows $row
	}
	$query close
	db close

	return $rows
}

# query db, parse everything and post in channels
proc ::funwar::sqlParsedb {server user password dbname tblname order chan \
	game limit command} {
	# query rows from table in database
	set rows [sqlGet $server $user $password $dbname $tblname $order \
		$limit]
	if {$rows == ""} {
		return
	}

	if { $command != "noheader" } {
		# post header in every given channel
		foreach channel $chan {
			postHeader $channel
		}
	}

	# parse earch row and post them in channels
	foreach row $rows {
		set id [dict get $row id]
		set date [dict get $row date]
		set time [dict get $row time]
		set xonx [dict get $row xonx]
		set clantag [dict get $row clantag]
		set irc [dict get $row irc]
		set www [dict get $row www]
		set server [dict get $row server]
		set org [dict get $row org]

		foreach channel $chan {
			# post row in every given channel
			post $game $id $date $time $xonx $clantag $irc $www \
				$server $org $channel
		}
	}

	if { $command != "nofooter" } {
		# post footer in every given channel
		foreach channel $chan {
			postFooter $channel
		}
	}
}

# helper for posting rtcw entries
proc ::funwar::postRtcw {chan limit command} {
	variable sqlServer
	variable sqlUser
	variable sqlPassword
	variable sqlDbnameRtcw
	variable sqlTblnameRtcw

	set order "id"
	set game "RTCW"

	sqlParsedb $sqlServer $sqlUser $sqlPassword $sqlDbnameRtcw \
		$sqlTblnameRtcw $order $chan $game $limit $command
}

# helper for posting et entries
proc ::funwar::postEt {chan limit command} {
	variable sqlServer
	variable sqlUser
	variable sqlPassword
	variable sqlDbnameEt
	variable sqlTblnameEt

	set order "id"
	set game "ET"

	sqlParsedb $sqlServer $sqlUser $sqlPassword $sqlDbnameEt \
		$sqlTblnameEt $order $chan $game $limit $command
}

# handle the !rtcw trigger
proc ::funwar::rtcw { nick host hand chan arg } {
	# check channel flag if enabled in this channel
	if {![channel get $chan funwar]} {
		return 0
	}

	set limit "10"
	set command ""
	postRtcw $chan $limit $command

	return 1
}

# handle the !et trigger
proc ::funwar::et { nick host hand chan arg } {
	# check channel flag if enabled in this channel
	if {![channel get $chan funwar]} {
		return 0
	}

	set limit "10"
	set command ""
	postEt $chan $limit $command

	return 1
}

# handle the !funwars trigger
proc ::funwar::both { nick host hand chan arg } {
	# check channel flag if enabled in this channel
	if {![channel get $chan funwar]} {
		return 0
	}

	set limit "3"
	set command "nofooter"
	postRtcw $chan $limit $command

	set command "noheader"
	postEt $chan $limit $command

	return 1
}

# handle cron auto posting
proc ::funwar::auto { min hour day month year } {
	# determine list of channels to post in based on channel flag
	set autoChannels ""
	foreach botChan [channels] {
		# only use channels the bot is on and have the flag enabled
		if {![botonchan $botChan] || ![channel get $botChan funwar]} {
			continue
		}
		lappend autoChannels $botChan
	}
	if {$autoChannels == ""} {
		# no channels to post in
		return
	}

	set limit "3"
	set command "nofooter"
	postRtcw $autoChannels $limit $command

	set command "noheader"
	postEt $autoChannels $limit $command
}

namespace eval ::funwar {
	bind pub - $triggerEt ::funwar::et
	bind pub - $triggerRtcw ::funwar::rtcw
	bind pub - $triggerBoth ::funwar::both
	bind cron - $autoCron ::funwar::auto
	putlog "Loaded funwars.tcl"
}
