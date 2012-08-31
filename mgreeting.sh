#!/bin/bash

# this is a cronjob which runs daily a 6am and then waits for the sunrise
# before waking me up - I used to use music but I found I mwas much more
# interested in the forecast and sometimes I could hear it properly over the
# music - I have left the code here - you can uncomment and use if you like - of
# course you can make it play AFTER it has spoken  - again, up to you...
#
# the RFID system in place at the front door tells the script if I'm home and
# also if I had a late night - it will choose to let me sleep in a few hours
# or not bother running at all, depending on these factors
#
# if you don't have such a system, then obviously it will run every day at
# sunrise no matter what - possibly you can hand-input or use cron to update
# the file with this information, or use whatever you use - it's just a plain
# text file and the syntax of what it contains is pretty easy to work out:
#
# two letter code for if I'm IN or OUT followed by a dot followed by the hour
# (in 24hr format) that I came or went
#
# the days.txt file should hopefully be equally as easy to work out:
# day of year(three digits), sunrise, sunset and midday times - all separated
# by spaces (yes clearly midday does not happen at 12:00 every day - this is
# why you need to be careful about sunscreen!)
#
# I use Festival for the speech:
# http://www.cstr.ed.ac.uk/projects/festival/
#
# I believe this comes preinstalled on Macs, otherwise you may have to use
# sudo apt-get install festival
# or something...



# if I'm out, don't bother...
whm=`cat micis`
mst=`echo ${whm:0:2}`
if [ "$mst" != "in" ] ; then
	exit 0
fi

# feel free to play with this adjustment variable to suit - basically, if I've
# had a late night, I get a few extra hours to sleep in...
to=`echo ${whm: -2}`
if [ $to -lt 3 ] ; then
	adj=6300
elif [ $to -ge 3 -a $to -lt 8 ] ; then
	exit 0
else
	adj=60
fi

td=`date +%j`
today=`cat days.txt|grep $td`
sr=`echo ${today:4:5}`
tar=`date -d $sr +%s`
cur=`date +%s`
tl=$(( $tar - $cur + $adj ))

# wait a number of seconds, depending on the above adjustments...
sleep $tl

# play music, don't play music - whatever - if you DO choose to use this you
# will probably want to sort out a fifo file so you can control mplayer when
# it is running from, say, a remote control, or programmatically - otherwise
# turning the music OFF may become a problem...

#chill.sh
#sleep 6

# so the fact I do all this AFTER waiting, means I get a few extra seconds sleep
x=`cat weather`

fc="${x:3}"
foc="${fc%l:*}"
high="${fc#*h:}"
l1="${fc%h:*}"
low="${l1#*l:}"
hilen="${#high}"
lolen="${#low}"

a=`curl -s --connect-timeout 30 "http://webservice.weatherzone.com.au/rss/wx.php?u=13145&lt=aploc&lc=5594&obs=1&fc=1&warn=1" | grep "Temperature" | sed -e 's,.*/b> \(.*\)&.*,\1,'`

echo "Good morning, Mike all" | festival --tts
echo "Hope you had a good sleep..." | festival --tts

if [ "$x" == "sorry" ] ; then
	echo "I'm sorry... I could not fetch a weather report this morning" | festival --tts
else
	echo "The forecast for today is..." $foc | festival --tts
	if [ $hilen -gt 0 ]; then
		if [ $lolen -gt 1 ] ; then
			echo "with a low of" $low "degrees... and a high of" $high "degrees..." | festival --tts
		else
			echo "with a high of" $high "degrees..." | festival --tts
		fi
	elif [ $lolen -gt 1 ]; then
		echo "with a low of" $low "degrees..." | festival --tts
	fi
fi
	
dow=`date +%A`
m=`date +%B`
dom=`date +%e`
th=`date +%l`
tm=`date +%M`
tp=`date +%p`
apm="${tp:0:1}"
if [ $th -eq 10 ] ; then
	hour="ten"
elif [ $th -eq 11 ] ; then
	hour="eleven"
elif [ $th -eq 12 ] ; then
	hour="twelve"
else
	hour=$th
fi

if [ "$a" != "" ] ; then
	echo "The temperature right now is" $a "degrees..." | festival --tts
	echo "on this "$dow" "$m" "$dom"... The current time is "$hour $tm $apm "M" | festival --tts
else
	echo "today is "$dow" "$m" "$dom"... The current time is "$hour $tm $apm "M" | festival --tts
fi

# so I have left out my own personal birthdays and whatever else I need to
# be reminded of - the below uses dummy figures to give you and idea how this
# works - one day, if I could be bothered I might dive into the XML from my
# Google calendar and plug that in here instead...
fdat=`date +%F`
bdat="${fdat:5}"
if [ "$bdat" == "04-29" ] ; then
	echo "... and have a happy birthday" | festival --tts
fi

if [ "$bdat" == "12-08" ] ; then
	echo "... don't forget to wish SOME GUY a happy birthday today" | festival --tts
fi

exit 0
