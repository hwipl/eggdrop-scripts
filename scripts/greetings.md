# greetings.tcl

The script [greetings.tcl](greetings.tcl) greets people who join channels.

## Setup

You can enable the greetings for a specific channel by setting the `greetings`
flag for the channel in your Eggdrop. For example, enable the script in the
channel `#test` with the following Eggdrop command:

```
.chanset #test +greetings
```

Accordingly, you can disable the greetings for a specific channel by removing
the `greetings` flag from the channel in your Eggdrop. For example, disable the
script in the channel `#test` with the following Eggdrop command:

```
.chanset #test -greetings
```

## Usage

There are no additional commands required to use this script. After enabling
the script in channels, the script automatically greets users who join these
channels.

## Examples

Example of a greeting from the bot after joining a channel:

```
14:37 -FooBot(lamest@10.0.1.4)- Hi hwipl!
```
