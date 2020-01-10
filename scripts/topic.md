# topic.tcl

The script [topic.tcl](topic.tcl) sets the topic in a channel with the `!topic`
command. Additionally, it contains examples of setting a specific topic, e.g.,
if a stream is online/offline with the `!on` and `!off` commands.

## Setup

You can configure the topics that are set with the `!on` and `!off` commands in
the following namespace variables that you can find at the top of the script:

```tcl
# topic for !on command
variable onTopic "Something is now online."

# topic for !off command
variable offTopic "Something is now offline."
```

You can enable the script in a specific channel by setting the `topic` flag for
the channel in your Eggdrop. For example, enable the script in the channel
`#test` with the following Eggdrop command:

```
.chanset #test +topic
```

Accordingly, you can disable the script in a specific channel by removing the
`topic` flag from the channel in your Eggdrop. For example, disable the script
in the channel `#test` with the following Eggdrop command:

```
.chanset #test -topic
```

## Usage

After enabling the script in a channel, you can use the commands in that
channel as shown below.

Set the topic in the channel to `<topic>`:

```
!topic <topic>
```

Set the configured `!on` topic:

```
!on
```

Set the configured `!off` topic:

```
!off
```

## Examples

Example of setting a topic:

```
20:59 <@hwipl> !topic This is a test
20:59 -!- FooBot changed the topic of #test to: This is a test
```

Example of setting the configured `!on` topic:

```
20:59 <@hwipl> !on
20:59 -!- FooBot changed the topic of #test to: Something is now online.
```

Example of setting the configured `!off` topic:

```
20:59 <@hwipl> !off
20:59 -!- FooBot changed the topic of #test to: Something is now offline.
```
