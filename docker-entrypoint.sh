#!/bin/bash -eu

cmd="$1"

/usr/local/bin/setup.sh

if [ "${cmd}" == "save-pharo" ]; then
     /usr/local/bin/save-pharo.sh ${@:2}
else
     /usr/bin/supervisord -n
fi
exit $?