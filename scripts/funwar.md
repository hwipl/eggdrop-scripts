# funwar.tcl

This script was created to post fun clan wars/matches for the two multiplayer
games RTCW and ET in channels periodically and with the commands below. The
matches are retrieved from tables in postreSQL databases.

```
Usage:
      !et                     post ET matches
      !rtcw                   post RTCW matches
      !funwars                post ET and RTCW matches

Enable for a channel with:    .chanset #channel +funwar
Disable for a channel with:   .chanset #channel -funwar
```

## Setup

The script requires a PostgreSQL server. So, this section shows an example of
how to setup the SQL server, eggdrop, and this script using docker containers.

### PostgreSQL

Run a new postgres container for eggdrop and set the password of the "postgres"
superuser:

```console
$ docker run --name eggdropPostgres \
	-e POSTGRES_PASSWORD=postgresUserPassword -d postgres
```

In the following steps, we assume that the new postgres server is listening on
the IP address 172.17.0.3.

Connect to postgres as superuser "postgres":

```console
$ docker run -it --rm --network bridge postgres psql -h 172.17.0.3 -U postgres
```

Add test schema for user "eggdrop" and add the user in the postgres session:

```sql
CREATE SCHEMA test;
CREATE USER eggdrop PASSWORD 'eggdropPassword';
GRANT ALL ON SCHEMA test TO eggdrop;
GRANT ALL ON ALL TABLES IN SCHEMA test TO eggdrop;
```

Disconnect superuser "postgres" from postgres:

```
\q
```

Reconnect to postgres as user "eggdrop":

```console
$ docker run -it --rm --network bridge postgres psql -h 172.17.0.3 \
	-d postgres -U eggdrop
```

Add table consisting of id, date, time, xonx, clantag, irc, www, server, and
org as user "eggdrop" in the postgres session:

```sql
CREATE TABLE test.funmatch(
   id SERIAL PRIMARY KEY,
   date DATE NOT NULL DEFAULT CURRENT_DATE,
   time TIME NOT NULL,
   xonx INTEGER NOT NULL,
   clantag VARCHAR (16) NOT NULL,
   irc VARCHAR (16) NOT NULL,
   www VARCHAR (256) NOT NULL,
   server VARCHAR (256) NOT NULL,
   org VARCHAR (128) NOT NULL
);
```

Insert some testing entries into the table:

```sql
INSERT INTO test.funmatch (time, xonx, clantag, irc, www, server, org)
VALUES
('18:30', 8, '[WIN]', '#win', 'www.winclan.com', 'et.winclan.com:1337',
'winrar'),
('19:30', 16, '[FAIL]', '#fail', 'www.failclan.com', 'et.failclan.com:7331',
'failbot'),
('20:30', 32, '<unknown>', '#unknown', 'www.unknownclan.com',
'et.unknownclan.com:3000', 'incognito');
```

Disconnect user "eggdrop" from postgres:

```
\q
```

### Eggdrop

The script uses the `tdbc::postgres` database connector. This connector
requires the `libpq` library that is not installed in the official eggdrop
docker image. So, you need to install it in the container. One way is shown in
the following steps:

The steps assume that you have an eggdrop container running, e.g., with a
command line similar to the following one:

```console
$ docker run -ti -e NICK=FooBot -e SERVER=172.17.0.2 \
	-v ~/eggdrop/data:/home/eggdrop/eggdrop/data \
	-v ~/eggdrop/custom-scripts:/home/eggdrop/eggdrop/custom-scripts \
	eggdrop
```

Get the ID of your running eggdrop container using `docker ps`, e.g.,
`abc123def456`. Then, attach to the running eggdrop container and run the bash
shell in it:

```console
$ docker exec -ti abc123def456 bash
```

Inside the shell session, install `libpq`:

```console
$ apk add libpq
```

Close the shell session, e.g., with `exit`. Then, commit your changes to a new
image called `eggdrop-custom`:

```
$ docker commit abc123def456 eggdrop-custom
```

After this, you can shut down your eggdrop container and restart it using the
new image, e.g., with a command line similar to the following one:

```console
$ docker run -ti -e NICK=FooBot -e SERVER=172.17.0.2 \
	-v ~/eggdrop/data:/home/eggdrop/eggdrop/data \
        -v ~/eggdrop/custom-scripts:/home/eggdrop/eggdrop/custom-scripts \
	eggdrop-custom
```

## Examples

This section shows examples of the output of the script in a channel. Note: the
same database and table was used for both games in these examples.

Example of periodic posting:

```
15:50 < FooBot> *** Funwars: ***
15:50 < FooBot> Game:   Date/Time:           XonX:  Clantag:     IRC:
15:50 < FooBot> RTCW    2020-01-03/20:30:00  32     <unknown>    #unknown
15:50 < FooBot> RTCW    2020-01-03/19:30:00  16     [FAIL]       #fail
15:50 < FooBot> RTCW    2020-01-03/18:30:00  8      [WIN]        #win
15:50 < FooBot> ET      2020-01-03/20:30:00  32     <unknown>    #unknown
15:50 < FooBot> ET      2020-01-03/19:30:00  16     [FAIL]       #fail
15:50 < FooBot> ET      2020-01-03/18:30:00  8      [WIN]        #win
15:50 < FooBot> *** end of funwars list ***
```

Example of the `!et` command:

```
16:00 <@hwipl> !et
16:00 < FooBot> *** Funwars: ***
16:00 < FooBot> Game:   Date/Time:           XonX:  Clantag:     IRC:
16:00 < FooBot> ET      2020-01-03/20:30:00  32     <unknown>    #unknown
16:00 < FooBot> ET      2020-01-03/19:30:00  16     [FAIL]       #fail
16:00 < FooBot> ET      2020-01-03/18:30:00  8      [WIN]        #win
16:00 < FooBot> ET      2020-01-03/20:30:00  32     FAIL         #fail
16:00 < FooBot> ET      2020-01-03/19:30:00  16     FAIL         #fail
16:00 < FooBot> ET      2020-01-03/18:30:00  8      FAIL         #fail
16:00 < FooBot> *** end of funwars list ***
```

Example of the `!rtcw` command:

```
16:00 <@hwipl> !rtcw
16:00 < FooBot> *** Funwars: ***
16:00 < FooBot> Game:   Date/Time:           XonX:  Clantag:     IRC:
16:00 < FooBot> RTCW    2020-01-03/20:30:00  32     <unknown>    #unknown
16:00 < FooBot> RTCW    2020-01-03/19:30:00  16     [FAIL]       #fail
16:00 < FooBot> RTCW    2020-01-03/18:30:00  8      [WIN]        #win
16:00 < FooBot> RTCW    2020-01-03/20:30:00  32     FAIL         #fail
16:00 < FooBot> RTCW    2020-01-03/19:30:00  16     FAIL         #fail
16:00 < FooBot> RTCW    2020-01-03/18:30:00  8      FAIL         #fail
16:00 < FooBot> *** end of funwars list ***
```

Example of the `!funwars` command:

```
16:00 <@hwipl> !funwars
16:00 < FooBot> *** Funwars: ***
16:00 < FooBot> Game:   Date/Time:           XonX:  Clantag:     IRC:
16:00 < FooBot> RTCW    2020-01-03/20:30:00  32     <unknown>    #unknown
16:00 < FooBot> RTCW    2020-01-03/19:30:00  16     [FAIL]       #fail
16:00 < FooBot> RTCW    2020-01-03/18:30:00  8      [WIN]        #win
16:00 < FooBot> ET      2020-01-03/20:30:00  32     <unknown>    #unknown
16:00 < FooBot> ET      2020-01-03/19:30:00  16     [FAIL]       #fail
16:00 < FooBot> ET      2020-01-03/18:30:00  8      [WIN]        #win
16:00 < FooBot> *** end of funwars list ***
```
