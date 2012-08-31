#!/bin/bash

# RFID at front door activates this script
# depending on if I'm coming or going, it will speak different things
# (yes I can still it from outside and you can shut up about that right now)
# the shopping list file "thelist" has been copied over from my home folder
# see:
# https://github.com/mmehmet/shop
#
# if you're not using the shopping list tool, feel free to delete that
# whole section, otherwise it will speak your entire shopping list to you
# as you leave - of course you can still access that from your phone when
# you're at the shops, so feel free to not use it anyway...

# alsa sucks - so make sure nothing messed with your audio levels:
amixer set PCM 100

# get current status
whereMic=`cat micis`
location=`echo ${whereMic:0:2}`

# got daylight?
td=`date +%j`
today=`cat days.txt|grep $td`
sunset=`echo ${today:10:2}`

hr=`date +%k`
to=`echo ${whm: -2}`
if [ $to -le $hr ] ; then
	tdf=$(($hr - $to))
else
	tdf=$(($hr + 24 - $to))
fi

# festival doesn't play nice with MythTV
mtv=`pgrep front`

# what to say when I am leaving:
if [ "$location" == "in" ] ; then
	# sort out timestamp FIRST, speak later
	stamp="out.$hr"
	echo $stamp > micis
	# it won't hurt to leave the MythTV catch if you don't actually have MythTV
	if [ "$mtv" == "" ] ; then
		echo "good bye mike all" | festival --tts
		if [ $hr -ge $sunset -o $hr -lt 4 ] ; then
			echo "hope you have a pleasant evening" | festival --tts
		else
			echo "have a good day" | festival --tts
			# shopping list
			# if you're not using the shopping list tool, this will do nothing
			arr=( $( < thelist ) )
			numits=${#arr[@]}
			if [ $numits -eq 0 ] ; then
				exit 0
			fi
			let itnums=$numits-1
			for (( i=0; i<${numits}; i++ )) ; do
				if [ $i -eq 0 ] ; then
					echo "we need" ${arr[$i]} | festival --tts
				elif [ $i -eq $itnums ] ; then
					echo "and" ${arr[$i]} | festival --tts
				else
					echo ${arr[$i]} | festival --tts
				fi
			done
		fi
	fi
fi

# what to say when I come home:
if [ "$location" == "ou" ] ; then
	# do stuff THEN speak...
	stamp="in.$hr"
	echo $stamp > micis
# if you actually use X10 to control the loungeroom lights then uncomment this
#	if [ $hr -ge $sunset ] ; then
#		lampon.sh
#	fi
	if [ "$mtv" == "" ] ; then
		echo "welcome back" | festival --tts
# and this
#		if [ $hr -ge $sunset ] ; then
#			echo "Ive turned on the light in the lounge room." | festival --tts
#			echo "I hope you don't mind." | festival --tts
#		fi
		if [ $tdf -lt 2 ] ; then
			# if I've just popped out, just a simple "welcome back" will suffice
			exit 0
		fi
        if [ $hr -le 12 -a $hr -ge 6 ] ; then
			echo "I hope you had a pleasant morning" | festival --tts
		elif [ $hr -ge $sunset -o $hr -lt 6 ] ; then
			echo "did you have a pleasant evening" | festival --tts
		else
			echo "hope you had a good afternoon" | festival --tts
		fi
		echo "it has been $tdf hours since you left" | festival --tts
	fi
fi
exit 0
