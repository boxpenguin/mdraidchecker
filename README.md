# mdraidchecker
Checks Linux software RAID

# Details

This code was created to monitor MD RAIDS within a linux environment. This was tested on a virtual machine running CentOS 6.6. Will need to be tested on other distos. 

# Operation

Report Mode: --report
Best suited for crons or user triggered. This profile will write all infromation to the logs at /var/log/raidchecker.log

Check Mode: --check
This will search for all MDRAIDs and perform a detail check on all them.

Log Mode: --log
This will allow easy navigation through the logs.

Watch Mode: --watch
Watch rebuild efforts of RAIDS
