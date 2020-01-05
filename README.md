# eggdrop-scripts

This repository contains a collection of long-forgotten scripts for the
[Eggdrop](http://eggheads.org) IRC bot. As a nostalgia project, they were
pulled from old backups, more or less rewritten and tested in a current Linux
environment. Some of the scripts are rather silly. So, please do not take them
too seriously.

Overview:

* [auth.tcl](scripts/auth.tcl): authenticate the bot with an authentication
  service when connecting to a server.
* [beer.tcl](scripts/beer.tcl): give users in a channel a cold beverage.
* [date.tcl](scripts/date.tcl): post the current date and time.
* [funwar.tcl](scripts/funwar.tcl): post scheduled online gaming fun matches
  retrieved from a SQL database.
* [greetings.tcl](scripts/greetings.tcl): greet users that join a channel.
* [help.tcl](scripts/help.tcl): post a help text.
* [host.tcl](scripts/host.tcl): resolve IP addresses or host names with the
  tool "host" and post the result.
* [insult.tcl](scripts/insult.tcl): generate random insults and post them.
* [maketiny.tcl](scripts/maketiny.tcl): generate tiny URLs and post them.
* [match.tcl](scripts/match.tcl): store scheduled online gaming matches in a
  text file and post stored matches.
* [qstat.tcl](scripts/qstat.tcl): query the status of online gaming servers
  with the tool "qstat" and post the result.
* [topic.tcl](scripts/topic.tcl): change the topic of a channel.
* [watch.tcl](scripts/watch.tcl): watch the online and offline status of users
  and post status changes.

## Requirements

The scripts are written for the IRC bot [Eggdrop](http://eggheads.org) in the
programming language [Tcl](https://tcl.tk). The tested versions are:

* Eggdrop 1.8.4
* TCL 8.6

You need an IRC server to test the bot with these scripts. You can use a public
one or run your own. The scripts were tested with the IRC server
[InspIRCd](https://www.inspircd.org/). The tested version is:

* InspIRCd 3.4.0

The script `funwar.tcl` requires a [PostgreSQL](https://www.postgresql.org)
server. The tested version is:

* PostgreSQL 12.1

The script `qstat.tcl` requires the tool
[qstat](https://github.com/multiplay/qstat). The tested version is:

* qstat 2.15 (Pre-release: commit 85fbecb on Dec 1, 2018)

The script `host.tcl` requires the tool "host" that is part of the
[bind](https://www.isc.org/bind/) tools. The tested version is:

* host/bind-tools 9.14.8
