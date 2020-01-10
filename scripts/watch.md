# watch.tcl

The script [watch.tcl](watch.tcl) watches users with the `!watch` command and
informs the caller when the user gets online or offline.

## Setup

You can enable the `!watch` command for a specific channel by setting the
`watch` flag for the channel in your Eggdrop. For example, enable the script in
the channel `#test` with the following Eggdrop command:

```
.chanset #test +watch
```

Accordingly, you can disable the `!watch` command for a specific channel by
removing the `watch` flag from the channel in your Eggdrop. For example,
disable the script in the channel `#test` with the following Eggdrop command:

```
.chanset #test -watch
```

## Usage

After enabling the script and the `!watch` command in a channel, you can use
the `!watch` command in that channel as shown below.

Start watching a user's status:

```
!watch add <user>
```

Stop watching a user's status:

```
!watch del <user>
```

Check a user's status once:

```
!watch check user
```

## Examples

Example of instructing the bot to check the status of a user, that is currently
offline. The reply is a query message:

```
21:13 <@hwipl> !watch check otheruser
21:13 <FooBot> otheruser is offline.
```

Example of instructing the bot to check the status of a user, that is currently
online. The reply is a query message:

```
21:13 <@hwipl> !watch check otheruser
21:13 <FooBot> otheruser is online.
```

Example of instructing the bot to start watching the status of a user. First,
the user is online but gets offline after the first check. The messages from
the bot are query messages:

```
21:13 <@hwipl> !watch add otheruser
21:13 <FooBot> otheruser is online.
21:14 <FooBot> otheruser is offline.
```

Example of instructing the bot to stop watching a user:

```
21:14 <@hwipl> !watch del otheruser
```
