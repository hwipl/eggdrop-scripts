# insult.tcl
#
# This rather silly script generates random insults and insults people with the
# !insult command.
#
# The script used to connect to insulthost.colorado.edu:1695 to get the
# insults. Unfortunately, the server does not exist any more. Apparently, the
# source code of the insultd created by garnett@colorado.edu that was running
# on insulthost.colorado.edu:1695 was released. The insultd source code can
# still be found in the attachments of the following Mozilla bugzilla:
# https://bugzilla.mozilla.org/show_bug.cgi?id=204356
# All the insults in this script are taken from the insultd source code.
#
# Usage:
# 	!insult                 insult yourself
#       !insult user            insult user
#
# Enable for a channel with:    .chanset #channel +insult
# Disable for a channel with:   .chanset #channel -insult
#
# See https://github.com/hwipl/eggdrop-scripts for the latest version and
# additional information including the license (MIT).

# tested versions, might run on earlier versions
package require Tcl 8.6
package require eggdrop 1.8.4

namespace eval ::insult {
	# channel flag for enabling/disabling
	setudef flag insult

	# insult parts from insultd.cf in insultd source code
	variable adjectives "acidic antique contemptible culturally-unsound
	despicable evil fermented festering foul fulminating humid impure inept
	inferior industrial left-over low-quality malodorous off-color
	penguin-molesting petrified pointy-nosed salty sausage-snorfling
	tastless tempestuous tepid tofu-nibbling unintelligent unoriginal
	uninspiring weasel-smelling wretched spam-sucking egg-sucking decayed
	halfbaked infected squishy porous pickled coughed-up thick vapid
	hacked-up unmuzzled bawdy vain lumpish churlish fobbing rank craven
	puking jarring fly-bitten pox-marked fen-sucked spongy droning gleeking
	warped currish milk-livered surly mammering ill-borne beef-witted
	tickle-brained half-faced headless wayward rump-fed onion-eyed
	beslubbering villainous lewd-minded cockered full-gorged rude-snouted
	crook-pated pribbling dread-bolted fool-born puny fawning sheep-biting
	dankish goatish weather-bitten knotty-pated malt-wormy saucyspleened
	motley-mind it-fowling vassal-willed loggerheaded clapper-clawed frothy
	ruttish clouted common-kissing pignutted folly-fallen plume-plucked
	flap-mouthed swag-bellied dizzy-eyed gorbellied weedy reeky measled
	spur-galled mangled impertinent bootless toad-spotted hasty-witted
	horn-beat yeasty imp-bladdereddle-headed boil-brained tottering
	hedge-born hugger-muggered elf-skinned"

	variable amounts "accumulation bucket coagulation enema-bucketful gob
	half-mouthful heap mass mound petrification pile puddle stack
	thimbleful tongueful ooze quart bag plate ass-full assload"

	variable nouns "bat|toenails bug|spit cat|hair chicken|piss dog|vomit
	dung fat-woman's|stomach-bile fish|heads guano gunk pond|scum rat|retch
	red|dye|number-9 Sun|IPC|manuals waffle-house|grits yoo-hoo dog|balls
	seagull|puke cat|bladders pus urine|samples squirrel|guts
	snake|assholes snake|bait buzzard|gizzards cat-hair-balls rat-farts
	pods armadillo|snouts entrails snake|snot eel|ooze slurpee-backwash
	toxic|waste Stimpy-drool poopy poop craptacular|carpet|droppings jizzum
	cold|sores anal|warts"
}

proc ::insult::insult { nick host hand chan arg } {
	variable adjectives
	variable amounts
	variable nouns

	# check channel flag if enabled in this channel
	if {![channel get $chan insult]} {
		return 0
	}

	# set name of insulted person
	set insultnick $nick
	if {$arg != ""} {
		set insultnick [lindex $arg 0]
	}

	# generate insult:
	# You are nothing but a(n) {adj1} {amt} of {adj2} {noun}
	set adj1 [lindex $adjectives [rand [llength $adjectives]]]
	set adj2 [lindex $adjectives [rand [llength $adjectives]]]
	set amt [lindex $amounts [rand [llength $amounts]]]
	set noun [lindex $nouns [rand [llength $nouns]]]
	set noun [string map {"|" " "} $noun]
	set an "a"
	if {[string match {[aeiouh]} [string index $adj1 0]]} {
		set an "an"
	}
	set insult "You are nothing but $an $adj1 $amt of $adj2 $noun"

	puthelp "PRIVMSG $chan :$insultnick: $insult"
	return 1
}

namespace eval ::insult {
	bind pub - !insult ::insult::insult
	putlog "Loaded insult.tcl"
}
