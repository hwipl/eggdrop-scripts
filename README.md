# eggdrop-scripts

This repository contains a collection of long-forgotten scripts for the
[Eggdrop](http://eggheads.org) IRC bot. As a nostalgia project, they were
pulled from old backups, more or less rewritten and tested in a current Linux
environment. Some of the scripts are rather silly. So, please do not take them
too seriously.

Overview:

* [auth](scripts/auth.md): authenticate the bot with an authentication
  service when connecting to a server.
* [beer](scripts/beer.md): give users in a channel a cold beverage.
* [date](scripts/date.md): post the current date and time.
* [funwar](scripts/funwar.md): post scheduled online gaming fun matches
  retrieved from a SQL database.
* [greetings](scripts/greetings.md): greet users that join a channel.
* [help](scripts/help.md): post a help text.
* [host](scripts/host.md): resolve IP addresses or host names with the
  tool "host" and post the result.
* [insult](scripts/insult.md): generate random insults and post them.
* [maketiny](scripts/maketiny.md): generate tiny URLs and post them.
* [match](scripts/match.md): store scheduled online gaming matches in a
  text file and post stored matches.
* [qstat](scripts/qstat.md): query the status of online gaming servers
  with the tool "qstat" and post the result.
* [topic](scripts/topic.md): change the topic of a channel.
* [watch](scripts/watch.md): watch the online and offline status of users
  and post status changes.

## Requirements

All scripts are written for the IRC bot [Eggdrop](http://eggheads.org) in the
programming language [Tcl](https://tcl.tk). The tested versions are:

* Eggdrop 1.8.4
* Tcl 8.6

The script `funwar.tcl` requires a [PostgreSQL](https://www.postgresql.org)
server. Additionally, the script depends on the PostgreSQL library `libpq` to
connect to the PostgreSQL server. The tested versions are:

* PostgreSQL 12.1
* libpq 12.1

The script `host.tcl` requires the tool "host" that is part of the
[bind](https://www.isc.org/bind/) tools. The tested version is:

* host/bind-tools 9.14.8

The script `maketiny.tcl` requires the tool
[wget](https://www.gnu.org/software/wget/) or something compatible. The tested
version is:

* wget/BusyBox v1.27.2

The script `qstat.tcl` requires the tool
[qstat](https://github.com/multiplay/qstat). The tested version is:

* qstat 2.15 (Pre-release: commit 85fbecb on Dec 1, 2018)

You need an IRC server to test the bot with these scripts. You can use a public
one or run your own. The scripts were tested with the IRC server
[InspIRCd](https://www.inspircd.org). If you want to interact with the bot and
the scripts, you need an IRC client. The scripts were tested with the client
[irssi](https://irssi.org). The tested versions are:

* InspIRCd 3.4.0
* irssi 1.2.2

## Setup

If you already have Eggdrop installed and configured, the basic setup of the
scripts in this repository consists of the following steps:

* Copy the scripts you want to use from the [scripts](scripts/) folder into
  your Eggdrop's scripts folder
* Install the dependencies of the scripts (see above)
* If necessary, adapt the variables/code inside the scripts
* Enable the scripts in the scripts section of your Eggdrop's config file with,
  e.g., `source scripts/date.tcl`
* (Re-)start your Eggdrop

## Docker

This repository contains Dockerfiles to create custom images of Eggdrop and
PostgreSQL, that are configured for the scripts in this repository. The
Dockerfiles were tested with docker version 1:19.03.5. You can build the images
with the following commands:

```console
$ docker image build -t custom-eggdrop -f eggdrop.Dockerfile .
$ docker image build -t eggdrop-postgres -f postgres.Dockerfile .
```

You can run a test setup that uses these images with the `docker-compose.yml`
file in this repository. It starts an InspIRCd, an eggdrop-postgres, and a
custom-eggdrop container. You can deploy it with the following command:

```console
$ docker stack deploy -c docker-compose.yml eggdrop-test
```

You can control your Eggdrop bot by attaching to the custom-eggdrop container.
For example, you can instruct your bot to join a channel (`.+chan #channel`)
and set channel flags to setup scripts in specific channels (`.chanset #channel
+flag`).

If you want to interact with your bot, you can run an IRC client like irssi and
connect to `localhost:6667`.
