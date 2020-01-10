# date.tcl

The script [date.tcl](date.tcl) shows the current date and time with the
`!date` command.

## Setup

You can enable the `!date` command for a specific channel by setting the
`date` flag for the channel in your Eggdrop. For example, enable the script in
the channel `#test` with the following Eggdrop command:

```
.chanset #test +date
```

Accordingly, you can disable the `!date` command for a specific channel by
removing the `date` flag from the channel in your Eggdrop. For example, disable
the script in the channel `#test` with the following Eggdrop command:

```
.chanset #test -date
```

## Usage

After enabling the script and the `!date` command in a channel, you can use the
`!date` command in that channel as shown below.

Show the current date and time:

```
!date
```

## Examples

Example of showing the current date and time (in the timezone of the bot):

```
14:16 <@hwipl> !date
14:16 < FooBot> Fri Jan 10 13:16:18 +0000 2020
```
