# match.tcl

The script [match.tcl](match.tcl) was originally created to save clan matches
in a file, to show all the saved matches and to be able to remove them from the
file again. But it could be used for storing, showing and deleting arbitrary
lines of text in a file.

## Setup

The command names can be changed in the following namespace variables that you
can find at the top of the script:

```tcl
# Names of the commands for adding, deleting and showing
variable addcommand "!addmatch"
variable delcommand "!delmatch"
variable showcommand "!showmatch"
```

You can enable the script for a specific channel by setting the `match` flag
for the channel in your Eggdrop. For example, enable the script in the channel
`#test` with the following Eggdrop command:

```
.chanset #test +match
```

Accordingly, you can disable the script for a specific channel by removing the
`match` flag from the channel in your Eggdrop. For example, disable the script
in the channel `#test` with the following Eggdrop command:

```
.chanset #test -match
```

## Usage

After enabling the script in a channel, you can use the commands in that
channel as shown below.

Add a match to the file/list:

```
!addmatch <match>
```

Show the saved matches:

```
!showmatch
```

Remove the match with number (as shown by `!showmatch`) from the file/list.
The numbers of remaining matches might change.

```
!delmatch <number>
```

## Examples

Example of adding matches:

```
17:25 <@hwipl> !addmatch [win] vs. [fail] 2020-01-23 23:00
17:25 <@hwipl> !addmatch [win] vs. [other] 2020-01-24 21:00
17:26 <@hwipl> !addmatch [fail] vs. [other] 2020-01-25 22:00
```

Example of showing matches:

```
17:26 <@hwipl> !showmatch
17:26 < FooBot> *** Match List ***
17:26 < FooBot> (1)  hwipl:  [win] vs. [fail] 2020-01-23 23:00
17:26 < FooBot> (2)  hwipl:  [win] vs. [other] 2020-01-24 21:00
17:26 < FooBot> (3)  hwipl:  [fail] vs. [other] 2020-01-25 22:00
17:26 < FooBot> *** End of Match List ***
```

Example of removing a match:

```
17:26 <@hwipl> !delmatch 2
17:27 <@hwipl> !showmatch
17:27 < FooBot> *** Match List ***
17:27 < FooBot> (1)  hwipl:  [win] vs. [fail] 2020-01-23 23:00
17:27 < FooBot> (2)  hwipl:  [fail] vs. [other] 2020-01-25 22:00
17:27 < FooBot> *** End of Match List ***
```
