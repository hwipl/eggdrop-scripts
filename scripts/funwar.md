# funwar.tcl

The script [funwar.tcl](funwar.tcl) was created to post fun clan wars/matches
for the two multiplayer games RTCW and ET in channels periodically and with the
commands below. The matches are retrieved from tables in postreSQL databases.

## Setup

The script requires databases on a PostgreSQL server that contains tables
consisting of `id`, `date`, `time`, `xonx`, `clantag`, `irc`, `www`, `server`,
and `org`. For example, you could create a table that works with the script on
your PostgreSQL server with the following sql statement:

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

The script uses the `tdbc::postgres` database connector to connect to your
PostgreSQL server. This connector requires the `libpq` library. If it is not
available on your system, you need to install it first.

At the top of the script you can find a section containing namespace variables
to configure the script. You can configure the SQL settings in the following
namespace variables:

```tcl
# sql server address, username and password
variable sqlServer "eggdroppostgres"
variable sqlUser "eggdrop"
variable sqlPassword "eggdropPassword"

# ET database and table on sql server
variable sqlDbnameEt "postgres"
variable sqlTblnameEt "test.funmatch"

# RTCW database and table on sql server
variable sqlDbnameRtcw "postgres"
variable sqlTblnameRtcw "test.funmatch"
```

You can configure how often the script posts in all enabled channels in the
following namespace variables:

```tcl
# crontab style definition of how often funwars are posted in channels
# format:
#       "MIN HOUR DAY MONTH YEAR"
# examples:
#       "20,50 * * * *"         post at minute 20 and 50 of every hour
#       "*/10 * * * *"          post every ten minutes
variable autoCron "20,50 * * * *"
```

You can configure the names of the commands (triggers) and the output headers
and footer in the following namespace variables:

```tcl
# trigger configuration for ET, RTCW and both
variable triggerEt "!et"
variable triggerRtcw "!rtcw"
variable triggerBoth "!funwars"

# output configuration
variable outputHeader "*** Funwars: ***"
variable outputHeader2 "Game: Date/Time: XonX: Clantag: IRC:"
variable outputFooter "*** end of funwars list ***"
}
```

You can enable the script in a specific channel by setting the `funwar` flag
for the channel in your Eggdrop. For example, enable the script in the channel
`#test` with the following Eggdrop command:

```
.chanset #test +funwar
```

Accordingly, you can disable the script in a specific channel by removing the
`funwar` flag from the channel in your Eggdrop. For example, disable the script
in the channel `#test` with the following Eggdrop command:

```
.chanset #test -funwar
```

## Usage

After enabling the script in a channel, you can use the commands in that
channel as shown below.

Post ET matches:

```
!et
```

Post RTCW matches:

```
!rtcw
```

Post ET and RTCW matches:

```
!funwars
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
