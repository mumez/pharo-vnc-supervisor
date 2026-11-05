#!/bin/bash

ORIGDIR=`pwd`
BASEDIR=/usr/local/bin/pharo
PHARO_CHANGE=${PHARO_IMAGE%.image}.changes

if [ -e /root/data/$PHARO_IMAGE ]; then
  BASEDIR=/root/data
fi

BLDDIR=$HOME/build
mkdir -p $BLDDIR
cp -f $BASEDIR/*.sources $BLDDIR
cp -f $BASEDIR/$PHARO_IMAGE $BLDDIR
cp -f $BASEDIR/$PHARO_CHANGE $BLDDIR
cd $BLDDIR

if [ $# -lt 2 ]; then
  echo "Usage: save-pharo.sh <pharo-subcommand> command params (e.g. metacello install <repo> <project>)" 1>&2
  exit 1
fi

# a log left by a previous run must not be taken for a failure of this run
rm -f PharoDebug.log

echo "## Pharo starts: $@"

if [ "$PHARO_MODE" == "headless" ]; then
    timeout ${PHARO_SAVE_TIMEOUT:-120} pharo -vm-display-null $PHARO_IMAGE ${@:1}
else
    pharo-ui $PHARO_IMAGE ${@:1}
fi
PHARO_STATUS=$?

if [ $PHARO_STATUS -ne 0 ] || [ -e PharoDebug.log ]; then
  if [ "$PHARO_MODE" == "headless" ] && [ $PHARO_STATUS -eq 124 ]; then
    echo "## Pharo timed out after ${PHARO_SAVE_TIMEOUT:-120} (PHARO_SAVE_TIMEOUT)." 1>&2
  fi
  echo "## FAILED! Pharo exit status: $PHARO_STATUS. Image was not saved." 1>&2
  if [ -e PharoDebug.log ]; then
    cp -f PharoDebug.log /root/data/PharoDebug-save-pharo.log
    echo "## See error log: /root/data/PharoDebug-save-pharo.log" 1>&2
  fi
  cd $ORIGDIR
  exit 1
fi

cp -f $PHARO_IMAGE /root/data/$PHARO_IMAGE
cp -f $PHARO_CHANGE /root/data/$PHARO_CHANGE

echo "## DONE! Saved Pharo image to: /root/data/$PHARO_IMAGE"

cd $ORIGDIR
exit 0

