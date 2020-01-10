# qstat.tcl

The script [qstat.tcl](qstat.tcl) stores game servers in a server list file and
queries their status with the utility
[qstat](https://github.com/multiplay/qstat) with the server commands below.

## Setup

The script requires the tool [qstat](https://github.com/multiplay/qstat). If it
is not available on your system, you need to install it first.

You can configure the names of the commands, the path to the `qstat` binary,
and the `qstat` options for querying all or a single server in the following
namespace variables. You can find them at the top of the script. The default
options are for the game Quake 2:

```tcl
# command names
variable addcommand "!addserver"
variable delcommand "!delserver"
variable showcommand "!serverlist"
variable refreshcommand "!refresh"

# path to your qstat binary
variable qstat "/usr/local/bin/qstat"

# qstat options for querying all servers
variable optionsall "-nh -u -default q2s"

# qstat options for querying single server
variable optionssingle "-nh -P -sort F -u -q2s"
```

You can enable the script in a specific channel by setting the `qstat` flag for
the channel in your Eggdrop. For example, enable the script in the channel
`#test` with the following Eggdrop command:

```
.chanset #test +qstat
```

Accordingly, you can disable the script in a specific channel by removing the
`qstat` flag from the channel in your Eggdrop. For example, disable the script
in the channel `#test` with the following Eggdrop command:

```
.chanset #test -qstat
```

## Usage

After enabling the script in a channel, you can use the commands in that
channel as shown below.

Add a server to the server list:

```
!addserver <server>
```

Remove a server from the server list:

```
!delserver <number>
```

Show the servers in the server list (without querying their status):

```
!serverlist
```

Query the status of all servers in the server list:

```
!refresh
```

Query the status of a single server in the server list and retrieve
information about the current players on the server:

```
!refresh <number>
```

## Examples

Example of adding Quake 2 servers to the server list:

```
17:59 <@hwipl> !addserver 212.42.38.88:27910
17:59 <@hwipl> !addserver 23.227.170.222:27916
17:59 <@hwipl> !addserver 50.209.196.145:27910
```

Example of showing the server list:

```
18:00 <FooBot> *** Server List ***:
18:00 <FooBot> (1)  212.42.38.88:27910
18:00 <FooBot> (2)  23.227.170.222:27916
18:00 <FooBot> (3)  50.209.196.145:27910
```

Example of querying all servers in the list:

```
18:00 <@hwipl> !refresh
18:00 < FooBot> (1) 212.42.38.88:27910    openffa PlayGround.ru - Deathmatch
                (16/20) (q2dm1)
18:00 < FooBot> (2) 23.227.170.222:27916  tastyspleen.net::dm
                (4/17)  (q2dm2)
18:00 < FooBot> (3) 50.209.196.145:27910  coop [HCI] Custom Coop - Vanilla,
                Xatrix, and Rogue.  Votable maps! (3/8)   (jail1)
```

Example of querying a specific server in the list and getting player
information (up to maximum message length). The player list was edited to hide
the real player names on that server:

```
18:00 <@hwipl> !refresh 1
18:00 < FooBot> (1) 212.42.38.88:27910    openffa PlayGround.ru - Deathmatch
                (16/20) (q2dm1)
18:00 < FooBot> Player1 (27 frags, 5ms), P2 (20 frags, 21ms), Player003 (17
                frags, 46ms), Play4 (16 frags, 23ms), Player00005 (14 frags,
                78ms), Player006 (13 frags, 25ms), Player7 (13 frags, 7ms),
                Player000008 (6 frags, 83ms), Player00009 (4 frags, 44ms), P10
                (4 frags, 109ms), Playe11 (1 frags, 61ms), Player000000012 (1
                frags, 7
```

Example of deleting a server from the server list:

```
18:01 <@hwipl> !delserver 2
18:01 <@hwipl> !refresh
18:01 < FooBot> (1) 212.42.38.88:27910    openffa PlayGround.ru - Deathmatch
                (16/20) (q2dm1)
18:01 < FooBot> (2) 50.209.196.145:27910  coop [HCI] Custom Coop - Vanilla,
                Xatrix, and Rogue.  Votable maps! (3/8)   (jail1)
```
