#!/bin/bash

echo "Pharo launch parameters:"
echo "PHARO_MODE: $PHARO_MODE"
echo "PHARO_IMAGE: $PHARO_IMAGE"
echo "PHARO_START_SCRIPT: '$PHARO_START_SCRIPT'"

# Launch Pharo
if [ "$PHARO_MODE" == "gui" ]; then
    echo "Launch Pharo in GUI mode"
    if [ -z "$PHARO_START_SCRIPT" ]; then
        pharo-ui $PHARO_IMAGE
    else
        pharo-ui $PHARO_IMAGE -e "$PHARO_START_SCRIPT"
    fi
else
    echo "Launch Pharo in non-gui mode"
    if [ -z "$PHARO_START_SCRIPT" ]; then
        pharo -vm-display-null $PHARO_IMAGE --no-quit
    else
        pharo -vm-display-null $PHARO_IMAGE --no-quit -e "$PHARO_START_SCRIPT"
    fi
fi
