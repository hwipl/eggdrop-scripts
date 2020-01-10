# insult.tcl

The rather silly script [insult.tcl](insult.tcl) generates random insults and
insults people with the `!insult` command.

The script used to connect to `insulthost.colorado.edu:1695` to get the
insults. Unfortunately, the server does not exist any more. Apparently, the
source code of the `insultd` created by `garnett@colorado.edu` that was running
on `insulthost.colorado.edu:1695` was released. The `insultd` source code can
still be found in the attachments of this [Mozilla
bugzilla](https://bugzilla.mozilla.org/show_bug.cgi?id=204356). All the insults
in this script are taken from the `insultd` source code.

## Setup

You can enable the `!insult` command for a specific channel by setting the
`insult` flag for the channel in your Eggdrop. For example, enable the script
in the channel `#test` with the following Eggdrop command:

```
.chanset #test +insult
```

Accordingly, you can disable the `!insult` command for a specific channel by
removing the `insult` flag from the channel in your Eggdrop. For example,
disable the script in the channel `#test` with the following Eggdrop command:

```
.chanset #test -insult
```

## Usage

After enabling the script and the `!insult` command in a channel, you can use
the `!insult` command in that channel as shown below.

Insult yourself:

```
!insult
```

Insult a specific user with the name `<user>`:

```
!insult <user>
```

## Examples

Example of insulting yourself:

```
16:11 <@hwipl> !insult
16:11 < FooBot> hwipl: You are nothing but a penguin-molesting puddle of warped
                seagull puke
```

Example of insulting an other user:

```
16:11 <@hwipl> !insult otheruser
16:11 < FooBot> otheruser: You are nothing but a measled half-mouthful of
                tofu-nibbling pond scum
```
