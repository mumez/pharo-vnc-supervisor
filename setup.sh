#!/bin/bash

# ensure initial pharo image
if ([ "$PHARO_IMAGE" = "Pharo.image" ] && [ ! -e "$PHARO_HOME/Pharo.image" ]) ; then
    cp /usr/local/bin/pharo/Pharo*.* $PHARO_HOME
fi

# supervisor log file
mkdir -p $PHARO_HOME/logs && touch $PHARO_HOME/logs/$PHARO_SUPERVISOR_LOG_NAME

# start base environments
/usr/local/bin/setup-envs-all.sh &
sleep 2