#!/usr/bin/awk

# Script name:  Awesome email log analyzer
# Creator:      Erin Dahlgren

# Description:  Matches patterns against email log records and computes statistics
#		for Spam, Ham, Infected emails, and for email users
# Usage: 	awk -f emailrep.awk <yourlogfile>
# Parameters: 	A log file formated in Amavis email client log style 


# Iterates through records (lines) and builds up counts based regex matching.  
# Associative arrays are used to stored dictionary-like counts
{ 
    if ($0 ~ /Passed CLEAN/) { 
	++passed  
	for (j=1; j<=NF; j++) {
	    if ($(j+1) ~ /->/) { ++sender[$j] }
	    if ($(j-1) ~ /->/) { ++receiver[substr($j,1,length($j)-1)] }
	}
    }
    if ($0 ~ /Blocked SPAM/) { 
	++spam 
	for(k=1; k<=NF; k++) { 
	    if ($k ~ /Hits/) { 
		spamscores += substr($(k+1),1,length($(k+1))-1)
	    } 
	} 
    } 
    if ($0 ~ /INFECTED/) { ++infected } 
} 
# a modular filtering and printing of the top ten of a numeric-valued associated array
# I couldn't find a really good awk sorting function.  (not asort(), which converts values to increments and requires gawk.) Any ideas?
function topten(a) {
    for (i=0; i<10; i++) {
	highest["num"] = 0
	for (x in a) {
	    if (a[x] > highest["num"]) { 
		highest["num"] = a[x]
		highest["name"] = x
	    }
	}
	if (highest["name"] == "<>") {  print "[e-mail hidden]: ", highest["num"] }
	if (highest["name"] != "<>" && highest["num"] != 0) { print highest["name"], ": ", highest["num"] }
	delete a[highest["name"]]
    }
}
# display and make prettified
END { 
    print " "
    print "10 top senders"
    print "--------------"
    topten(sender)
    print " "
    print "10 top recipients"
    print "-----------------"
    topten(receiver)
    print " "
    print "Stats"
    print "-----------------"
    print "Ham: ", passed
    print "SPAM: ", spam
    print "Average SPAM score: ", spamscores/spam
    print "SPAM to Ham ratio: ", spam/passed
    print "Infected: ", infected
}


