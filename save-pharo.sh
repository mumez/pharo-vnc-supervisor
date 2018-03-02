#!/bin/bash

ORIGDIR=`pwd`
BASEDIR=/usr/local/bin/pharo
PHARO_CHANGE=${PHARO_IMAGE%.image}.changes

if [ -e /root/data/$PHATO_IMAGE ]; then
  BASEDIR=/root/data
fi

BLDDIR=$HOME/build
mkdir -p $BLDDIR
cp -f $BASEDIR/$PHARO_IMAGE $BLDDIR
cp -f $BASEDIR/$PHARO_CHANGE $BLDDIR
cp -f $BASEDIR/Pharo*.sources $BLDDIR
cd $BLDDIR

echo "Pharo starts: ${@:$#}"

if [ $# -lt 2]; then
  echo "Usage: save-pharo.sh {get|config} command params" 1>&2
  exit 1
fi

pharo-ui $PHARO_IMAGE ${@:1}

echo "DONE! Save image to: /root/data/$PHARO_IMAGE"

cp -f $PHARO_IMAGE /root/data/$PHARO_IMAGE
cp -f $PHARO_CHANGE /root/data/$PHARO_CHANGE

cd $ORIGDIR
exit 0

