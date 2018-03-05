#!/bin/bash

# ensure initial pharo image
if ([ "$PHARO_IMAGE" = "Pharo.image" ] && [ ! -e "/root/data/Pharo.image" ]) ; then
    cp /usr/local/bin/pharo/Pharo*.* /root/data
fi

# supervisor log file
mkdir -p /root/data/logs && touch /root/data/logs/$PHARO_SUPERVISOR_LOG_NAME

# vnc
/bin/bash /dockerstartup/vnc_startup.sh &
