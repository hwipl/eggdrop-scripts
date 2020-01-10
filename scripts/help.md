# help.tcl

The script [help.tcl](help.tcl) shows a help text with the `!help` command.

## Setup

You can set the text that is shown by the `!help` command in the namespace
variable `helpText` that you can find at the top of the script:

```tcl
# help text
variable helpText {
	"*** command help: ***"
	" Quake2 Server List Commands:"
	"  !addserver ip:port  - add server with ip:port to list"
	"  !delserver number   - remove server with number from list"
	"  !serverlist         - show servers in list"
	"  !refresh            - refresh servers in list"
	"  !refresh number     - refresh server with number in list"
	" Others:"
	"  !help               - show this help"
	"  !insult user        - insult user with random insult"
	"*** end of help ***"
}
```

You can enable the `!help` command for a specific channel by setting the `help`
flag for the channel in your Eggdrop. For example, enable the script in the
channel `#test` with the following Eggdrop command:

```
.chanset #test +help
```

Accordingly, you can disable the `!help` command for a specific channel by
removing the `help` flag from the channel in your Eggdrop. For example, disable
the script in the channel `#test` with the following Eggdrop command:

```
.chanset #test -help
```

## Usage

After enabling the script and the `!help` command in a channel, you can use the
`!help` command in that channel as shown below.

Show help text:

```
!help
```

## Examples

Example of showing the pre-configured help text:

```
14:57 <FooBot> *** command help: ***
14:57 <FooBot>  Quake2 Server List Commands:
14:57 <FooBot>   !addserver ip:port  - add server with ip:port to list
14:57 <FooBot>   !delserver number   - remove server with number from list
14:57 <FooBot>   !serverlist         - show servers in list
14:57 <FooBot>   !refresh            - refresh servers in list
14:57 <FooBot>   !refresh number     - refresh server with number in list
14:57 <FooBot>  Others:
14:57 <FooBot>   !help               - show this help
14:57 <FooBot>   !insult user        - insult user with random insult
14:57 <FooBot> *** end of help ***
```
