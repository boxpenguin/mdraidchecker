#!/bin/bash
##################################
# Sets log location		 #
LOGFILE="raidchecker.log"
VAR="/var/log/"
LOG=$VAR$LOGFILE
TIMESTAMP="$(date +"%D %T")"
##################################

# clean up function
cleanup () {
rm /tmp/raid 2>/dev/null
rm /tmp/failed_raid 2>/dev/null
}

# creates raid listing
generate_raidlist () {
cleanup
touch /tmp/raid
touch /tmp/failed_raid
cat /proc/mdstat | grep md[[:digit:]] | awk '{ print "\/dev\/" $1}' 2> /dev/null 1>> /tmp/raid
grep -B1 _ /proc/mdstat | grep md[[:digit::]] | awk '{ print "\/dev\/" $1}' 2> /dev/null 1>> /tmp/failed_raid
}

# performs main reports to the logs
perform_report () {
if  grep -B1 -q _ /proc/mdstat ; then
        echo $TIMESTAMP >> $LOG
	echo "RAID FAILED" | tee -a $LOG
       	cat /proc/mdstat >> $LOG
	while read -r line
	do
		mdadm --detail $line
		mdadm --detail $line >> $LOG
	done < /tmp/failed_raid
else
	echo "RAID HEALTHY" | tee -a $LOG
	echo $TIMESTAMP >> $LOG
	cat /proc/mdstat >> $LOG
fi
}

# Manually checks raids
perform_check () {
echo "Displaying RAID stats please proceed with 'q': screen (1)/3." | less && cat /proc/mdstat | less && mdadm --detail /dev/md* | less
}

# Allows easy navigation of logs
perform_log () {
less $LOG
}

# CASE Menu
case $1 in
	"--report")
	generate_raidlist
	perform_report
	cleanup
	;;
	"--check")
	generate_raidlist
	perform_check
	cleanup
	;;
	"--log")
	generate_raidlist
	perform_log
	cleanup
	;;
	"")
	echo "--report; will output to logs as configured in ./raid.config"
	echo "--check; will ouput to screen will not track in logs"
	echo "--log; steps into the log"
	;;
esac
