#!/bin/bash

# this one is for the front door
# Port setting
stty -F /dev/ttyUSB0 9600 raw -echo

# Loop
while read -n64 CHAR
do
	rfdo.sh
done < /dev/ttyUSB0

exit 0
