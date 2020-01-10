# beer.tcl

The script [beer.tcl](beer.tcl) gives a beer to people with the `!beer`
command.

## Setup

You can enable the `!beer` command for a specific channel by setting the
`beer` flag for the channel in your Eggdrop. For example, enable the script in
the channel `#test` with the following Eggdrop command:

```
.chanset #test +beer
```

Accordingly, you can disable the `!beer` command for a specific channel by
removing the `beer` flag from the channel in your Eggdrop. For example, disable
the script in the channel `#test` with the following Eggdrop command:

```
.chanset #test -beer
```

## Usage

After enabling the script and the `!beer` command in a channel, you can use the
`!beer` command in that channel as shown below.

Give a beer to yourself:

```
!beer
```

Give a beer to a specific user with the name `<user>`:

```
!beer <user>
```

## Examples

Example of giving yourself a beer:

```
13:35 <@hwipl> !beer
13:35  * FooBot gives hwipl an ice cold beer.
```

Example of giving another user a beer:

```
13:35 <@hwipl> !beer otheruser
13:35  * FooBot gives otheruser an ice cold beer.
```
