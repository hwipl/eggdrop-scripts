# host.tcl

The script [host.tcl](host.tcl) resolves host names or IP addresses using the
tool "host" with the `!host` command.

## Setup

The script requires the tool "host" that is part of the
[bind](https://www.isc.org/bind/) tools. If the "host" tool is not available on
your system, you need to install it first.

You can change the path to the "host" tool in the namespace variable `hostCmd`
that you can find at the top of the script:

```tcl
# path to host tool
variable hostCmd "/usr/bin/host"
```

You can enable the `!host` command for a specific channel by setting the
`host` flag for the channel in your Eggdrop. For example, enable the script in
the channel `#test` with the following Eggdrop command:

```
.chanset #test +host
```

Accordingly, you can disable the `!host` command for a specific channel by
removing the `host` flag from the channel in your Eggdrop. For example, disable
the script in the channel `#test` with the following Eggdrop command:

```
.chanset #test -host
```

## Usage

After enabling the script and the `!host` command in a channel, you can use the
`!host` command in that channel as shown below.

Resolve name or IP address:

```
!host <name|ip>
```

## Examples

Example of resolving a host name:

```
15:38 <@hwipl> !host google.com
15:38 < FooBot> google.com has address 172.217.22.46
15:38 < FooBot> google.com has IPv6 address 2a00:1450:4001:814::200e
15:38 < FooBot> google.com mail is handled by 20 alt1.aspmx.l.google.com.
15:38 < FooBot> google.com mail is handled by 30 alt2.aspmx.l.google.com.
15:38 < FooBot> google.com mail is handled by 50 alt4.aspmx.l.google.com.
15:38 < FooBot> google.com mail is handled by 10 aspmx.l.google.com.
15:38 < FooBot> google.com mail is handled by 40 alt3.aspmx.l.google.com.
```

Example of resolving an IPv4 address:

```
15:39 <@hwipl> !host 172.217.22.46
15:39 < FooBot> 46.22.217.172.in-addr.arpa domain name pointer
                fra15s16-in-f14.1e100.net.
15:39 < FooBot> 46.22.217.172.in-addr.arpa domain name pointer
                fra15s16-in-f46.1e100.net.
```

Example of resolving an IPv6 address:

```
15:39 <@hwipl> !host 2a00:1450:4001:814::200e
15:39 < FooBot> e.0.0.2.0.0.0.0.0.0.0.0.0.0.0.0.4.1.8.0.1.0.0.4.0.5.4.1.0.0.a.
2.ip6.arpa domain name pointer fra15s11-in-x0e.1e100.net.
```
