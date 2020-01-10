# maketiny.tcl
#
# This script converts URLs into short URLs using https://tinyurl.com's service
# with the !tinyurl and !tinylast commands.
#
# Usage:
#       !tinyurl url            create tinyurl for url
#       !tinylast               create tinyurl for last url in channel
#
# Enable for a channel with:    .chanset #channel +maketiny
# Disable for a channel with:   .chanset #channel -maketiny
#
# See https://github.com/hwipl/eggdrop-scripts for the latest version and
# additional information including the license (MIT).

# tested versions, might run on earlier versions
package require Tcl 8.6
package require eggdrop 1.8.4

namespace eval ::maketiny {
	# channel flag for enabling/disabling
	setudef flag maketiny

	# file name for channel's last url, channel name will be appended
	variable urlFilePrefix "maketiny_lasturl_"
}

# convert given url to short url
proc ::maketiny::tinyurl {nick host hand chan argv} {
	set wget "wget --quiet --output-document=-"
	set command "$wget https://tinyurl.com/create.php?url="
	set example "Example: !tinyurl http://www.google.com"
	set usage "Usage: !tinyurl <url>  || $example"

	# check channel flag if enabled in this channel
	if {![channel get $chan maketiny]} {
		return 0
	}

	# first argument must be the url
	if { [llength $argv] == 0 } {
		puthelp "PRIVMSG $nick :$usage"
		return 0
	}
	set url [lindex $argv 0]

	# open command to create tinyurl and retrieve the html document
	# returned by tinyurl
	set command "|$command$url"
	set pattern {data-clipboard-text=\"(https+://tinyurl.com/\w+)\".+}
	set output ""
	if {![catch {open $command r} input]} {
		while {[gets $input line] >= 0} {
			# extract the tiny url from the html file
			if {[regexp $pattern $line match tinyurl]} {
				set output $tinyurl
			}
		}
		close $input
	}

	if {$output == ""} {
		putlog "Error getting tinyurl."
		return 0
	}
	puthelp "PRIVMSG $chan :$output"
	return 1
}

# convert last url in channel to short url
proc ::maketiny::tinylast {nick host hand chan argv} {
	variable urlFilePrefix
	set urlFile "$urlFilePrefix$chan"

	# check channel flag if enabled in this channel
	if {![channel get $chan maketiny]} {
		return 0
	}

	# read last url from channel's url file and create tinyurl
	if {![catch {open $urlFile r} input]} {
		while {[gets $input line] >= 0} {
			set url $line
		}
		close $input
		tinyurl $nick $host $hand $chan $url
		return 1
	}
	return 0
}

# set last url in channel
proc ::maketiny::lasturl {nick host hand chan argv} {
	variable urlFilePrefix
	set urlFile "$urlFilePrefix$chan"

	# check channel flag if enabled in this channel
	if {![channel get $chan maketiny]} {
		return 0
	}

	# if message contains url, add it to channel's url file
	# url is assumed to start with http[s]://
	set pattern {(https?://\S*)}
	if {[regexp $pattern $argv match url] != 0} {
		if {![catch {open $urlFile w} output]} {
			puts $output $url
			close $output
			return 0
		}
	}
	return 1
}

namespace eval ::maketiny {
	bind pub - !tinyurl ::maketiny::tinyurl
	bind pub - !tinylast ::maketiny::tinylast
	bind pubm - * ::maketiny::lasturl
	putlog "Loaded maketiny.tcl"
}
