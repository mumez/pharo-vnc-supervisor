#!/bin/bash

# ensure initial pharo image
if ([ "$PHARO_IMAGE" = "Pharo.image" ] && [ ! -e "$PHARO_HOME/Pharo.image" ]) ; then
    cp /usr/local/bin/pharo/Pharo*.* $PHARO_HOME
fi

# supervisor log file
mkdir -p $PHARO_HOME/logs && touch $PHARO_HOME/logs/$PHARO_SUPERVISOR_LOG_NAME

# start base environments (skip in headless mode)
if [ "$PHARO_MODE" != "headless" ]; then
    # X is not running yet, so these can only be leftovers from before a container restart.
    # Xvfb refuses to start if they remain.
    rm -f /tmp/.X0-lock /tmp/.X11-unix/X0
    /usr/local/bin/setup-envs-all.sh &
    sleep 2
fi