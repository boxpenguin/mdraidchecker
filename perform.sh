#!/bin/bash
##################################
# Sets log location              #
LOGFILE="raidchecker.log"
# Sets time stamp and log info   #
TIMESTAMP="$(date +"%D %T")"
STATS="$(cat /proc/mdstat)"
VAR="/var/log/"
LOG=$VAR+$LOGFILE
##################################

echo "Checking status of Software RAID"

# check if failed
rm /tmp/failmd 2>/dev/null
touch /tmp/failmd
if  grep -B1 -q _ /proc/mdstat ; then
        echo "RAID FAILED" | tee -a $LOG
        echo $TIMESTAMP >> $LOG
        cat /proc/mdstat >> $LOG
       	# Display more useful info
       	# TODO: redirect to mail perhaps?
        grep -B1 _ /proc/mdstat | grep md* | awk '{ print "\/dev\/" $1}' 2> /dev/null 1>> /tmp/failmd
        while read -r line
        do
          	mdadm --detail $line
        done < /tmp/failmd
else
    	echo "RAID HEALTHY" | tee -a $LOG
        echo $TIMESTAMP >> $LOG
        cat /proc/mdstat >> $LOG
fi

rm /tmp/failmd 2>/dev/null
cat $LOG
# grep --color -B1 _ /proc/mdstat && mdadm --detail /dev/`grep -B1 _ /proc/mdstat | grep md* | awk '{print $1}'`
