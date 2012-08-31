#!/bin/bash

# with slight adjudtments for time of year (which will greatly depend on your
# latitude) pick a random number and wait that random number of minutes
# before turning on the lights in the living room
#
# this can be run as a cronjob at, say 4pm every day

mth=`date +%b`

case $mth in
	Jan)
		sleep 10800;;
	Feb)
		sleep 9000;;
	Mar)
		sleep 7200;;
	Apr)
		sleep 3600;;
	May)
		sleep 900;;
	*)
esac

RANGE=30

number=$RANDOM
let "number %= $RANGE"

let "mins = 60*$number"

sleep $mins

whm=`cat micis`
loc=`echo ${whm:0:2}`
if [ "$loc" == "in" ] ; then
	# only turn on the lights if I am home
	lampon.sh
fi

exit 0
