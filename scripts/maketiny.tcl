# cheap tinyurl script to convert ling urls into short urls
# using http://tinyurl.com´s service

proc tinyurl_convert {nick host hand chan argv} {

# set variables

set url [lindex $argv 0]
set command "|wget --quiet --output-document=- http://tinyurl.com/create.php?url=$url"

# check if there are enough arguments

if { [llength $argv] == 0 } {
	puthelp "PRIVMSG $nick :Usage: !tinyurl <url>  || Example: !tinyurl http://www.google.com"
} else {

# open command to create tinyurl and retrieve the html document returned by tinyurl

if ![catch {open $command r} input] {
	while {[gets $input line] >= 0} {

		# regexp to extract the right part of the html file and the get the tiny url
		# output tiny url

		if [regexp {<input type=hidden name=tinyurl value=\"(.*)\">} $line match tinyurl] {
				puthelp "PRIVMSG $chan :$tinyurl"
		}

	}
	close $input
}
}
}
proc tinyurl_tinylast {nick host hand chan argv} {
	set urlhistory "url_history_$chan"
	if ![catch {open $urlhistory r} input] {
		while {[gets $input line] >= 0} {
			set url $line
		}
		close $input
		tinyurl_convert $nick $host $hand $chan $url
	}
}

proc tinyurl_urlhistory {nick host hand chan argv} {
	set urlhistory "url_history_$chan"

	if {[regexp {(http://\S*)} $argv match url] != 0} {
		if ![catch {open $urlhistory w} output] {
			puts $output $url
			close $output
		}
	}
}


# bind channel command

bind pub - !tinyurl tinyurl_convert
bind pub - !tinylast tinyurl_tinylast
bind pubm - * tinyurl_urlhistory
