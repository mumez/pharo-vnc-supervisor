#!/bin/bash

# supervisor log file
mkdir -p /root/data/logs && touch /root/data/logs/$PHARO_SUPERVISOR_LOG_NAME

# vnc
/bin/bash /dockerstartup/vnc_startup.sh &
