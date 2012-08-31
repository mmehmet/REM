#!/bin/bash

# this runs as a cronjob at, say 10pm every night, and waits a random number
# of minutes before turning off the lights in the living room
#
# it actually works great as a reminder IT IS TIME TO GO TO BED

RANGE=30

number=$RANDOM
let "number %= $RANGE"

let "mins = 60*$number"

sleep $mins

lampoff.sh

# there used to be a section which also turned on the lights in the bedroom
# here but I found that less useful
#sleep 30
#room.sh

exit 0
