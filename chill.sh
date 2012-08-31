#!/bin/bash

# this script toggles mplayer on and off
state=`pgrep mplayer -c`

if [ $state -gt 0 ] ; then
	echo "off" > musicstate
	pkill mplayer
	pkill chill
	amixer set PCM 100
	exit 0
fi

echo "on" > musicstate
amixer set PCM 12
# you will need to create your own "mplayer.fifo" file - or else if you don't
# want to be able to control mplayer when it is running, just leave out
# the "-slave -input file=/home/mic/mplayer.fifo" part of this command
mplayer -ao alsa -really-quiet -slave -input file=/home/mic/mplayer.fifo -playlist http://broadcast.infomaniak.ch/jazzlounge-high.mp3.m3u &

# since this is a smooth jazz station, I turn down the volume - again, you
# will need the fifo file for this functionality
echo "volume 33 1" > /home/mic/mplayer.fifo

exit 0
