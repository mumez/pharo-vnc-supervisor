pharo-vnc-supervisord
========

A Docker image for [Pharo Smalltalk](http://www.pharo-project.org/ "Pharo"). Especially suitable for web application development and delivery.

- Pharo process is daemonized by supervisord.
- Debuggable via VNC.
- Web browsers (Firefox and Chronium) are installed.


## Usages ##

```bash
docker run -d -p 5901:5901 -p 6901:6901 mumez/pharo-vnc-supervisor
```

You can access the running pharo image via VNC client (the default password is 'vncpassword').

For web browser: `http://localhost:6901/?password=vncpassword`

## Settings ##

You can change these settings via `docker run` `-e` option.

### Pharo related environment variables
```
PHARO_SUPERVISOR_LOG_NAME=pharo-supervisord.log
PHARO_IMAGE_VERSION=61
PHARO_IMAGE=Pharo.image
PHARO_START_SCRIPT=
PHARO_MODE=gui
```
### VNC related environment variables

Please see [ubuntu-icewm-vnc]
(https://hub.docker.com/r/consol/ubuntu-icewm-vnc/).

