#!/bin/bash

# this runs as a cronjob every day at 4pm and then waits for the sun to set
# (actually it goes a little early because it can get dark pretty quick
# at sunset, depending on where you live) and then turns on the lights in
# the living room
#
# there is another script called "randlon.sh" which does the same thing but
# with random numbers instead of a file with sunrise and sunset times - I
# no longer use it (mainly because I prefer the reliability - some days it
# would seem to take forever and other days the lights would come on and it
# was still pretty bright outside) but I have included it here in case someone
# else might have different preferences
#
# as mentioned, this uses a file called "days.txt" which lists the sunrise
# and sunset times for every day of the year - this file needs to be slightly
# tweaked every year, due to daylight savings, but it's not that hard to
# maintain...
#
# there is also a "season" file which splits the year into "hotter" and "colder"
# according to a very patient cron job which only executes twice a year - I
# am not totally convinced about the reliablity of this, but left it in case
# anyone wants to tweak it
#
# if you don't want to use it, simply hard-code the "adj" variable to, say,
# 900 - or leave it out altogether - again, depending on your latitude...

sson=`cat season`
if [ "$sson" == "colder" ] ; then
	adj=900
else
	adj=1800
fi

td=`date +%j`
today=`cat days.txt|grep $td`
sunset=`echo ${today:10:5}`
tar=`date -d $sunset +%s`
cur=`date +%s`
tl=$(( $tar - $cur - $adj ))

# so the amount it sleeps depends on when it ran (I suppose you could hard-code
# that too) and the "adj" factor - which means the lights come son BEFORE
# the sun has actually gone down...
sleep $tl

whm=`cat micis`
loc=`echo ${whm:0:2}`
if [ "$loc" != "in" ] ; then
	exit 0
fi

# AZIZ! LIGHT!
lampon.sh
exit 0

