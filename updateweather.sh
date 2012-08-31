#!/bin/bash

# I get my forecast from the BoM and output to a file in one single line
# for easy parsing by other applications such as conky...
x=`curl -s --connect-timeout 30 "ftp://ftp2.bom.gov.au/anon/gen/fwo/IDA00003.html" | grep "Melbourne" | sed -e 's,&nbsp;,,g' -e 's/<\/TD>/\]/g' -e 's/<[^>]*>//g' | awk -F ']' '{print "fc:"$4 "l:"$5 "h:"$6}'`

if [ "$x" == "" ] ; then
	echo "sorry" > weather
else
	echo $x > weather
fi

exit 0
