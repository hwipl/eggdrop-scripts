# maketiny.tcl

The script [maketiny.tcl](maketiny.tcl) converts URLs into short URLs using the
service of [TinyURL](https://tinyurl.com) with the `!tinyurl` and `!tinylast`
commands.

## Setup

The script requires the tool [wget](https://www.gnu.org/software/wget/). If it
is not available on your system, you need to install it first.

You can enable the `!tinyurl` and `!tinylast` commands for a specific channel
by setting the `maketiny` flag for the channel in your Eggdrop. For example,
enable the script in the channel `#test` with the following Eggdrop command:

```
.chanset #test +maketiny
```

Accordingly, you can disable the `!tinyurl` and `!tinylast` commands for a
specific channel by removing the `maketiny` flag from the channel in your
Eggdrop. For example, disable the script in the channel `#test` with the
following Eggdrop command:

```
.chanset #test -maketiny
```

## Usage

After enabling the script and the `!tinyurl` and `!tinylast` commands in a
channel, you can use the these commands in that channel as shown below.

Create a tinyurl for an url:

```
!tinyurl <url>
```

Create a tinyurl for the last url in channel:

```
!tinylast
```

## Examples

Example of creating a tinyurl for a specific url:

```
16:48 <@hwipl> !tinyurl www.google.com
16:48 < FooBot> https://tinyurl.com/1c2
```

Example of creating a tinyurl for the last url in the channel:

```
16:48 <@hwipl> http://google.com
16:48 <@hwipl> !tinylast
16:48 < FooBot> https://tinyurl.com/2tx
```
