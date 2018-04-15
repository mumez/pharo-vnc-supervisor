# pharo-vnc-supervisor

A Docker image for [Pharo Smalltalk](http://www.pharo-project.org/ "Pharo"). Especially suitable for web application development and delivery.

- Pharo process is daemonized by supervisord.
- Debuggable via VNC.
- Web browsers (Firefox and Chronium) are installed.

## Usages

```bash
docker run --name my_pharo -d -p 5901:5901 -p 6901:6901 mumez/pharo-vnc-supervisor
```

You can access the running pharo image via VNC client or web browser.
(the default password is 'vncpassword')

- VNC client:  `yourhost:5901`
- Web browser: `http://yourhost:6901/?password=vncpassword`

### How to start with a customized Pharo image

1. Place your customized Pharo image to your docker-host data directory (For example, `$HOME/docker/pharo/data`).
2. Use `docker run` `-v` option to mount the data direcotry.

```bash
docker run --name my_pharo -d -p 5901:5901 -p 6901:6901 \
	-v=$HOME/docker/pharo/data:/root/data \
	mumez/pharo-vnc-supervisor
```

Currently for Pharo 7.0, there is also 'pharo70' tag maintained. So you can just specify the tag:

```bash
docker run --name my_pharo -d -p 5901:5901 -p 6901:6901 mumez/pharo-vnc-supervisor:pharo70
```

### How to build a customized Pharo image in a container

You can use `save-pharo` command to build a customized Pharo image.

#### Install from Catalog

`save-pharo get <Project name>`

```bash
docker run --rm -p 5901:5901 -p 6901:6901 \
	-v=$HOME/docker/pharo/data:/root/data \
	mumez/pharo-vnc-supervisor \
	save-pharo get Tarantube
```

#### Install by Configuration

`save-pharo config <Metacello configuration>`

```bash
docker run --rm -p 5901:5901 -p 6901:6901 \
	-v=$HOME/docker/pharo/data:/root/data \
	mumez/pharo-vnc-supervisor \
	save-pharo config http://smalltalkhub.com/mc/Pharo/MetaRepoForPharo60/main/ \
	ConfigurationOfNeo4reSt --install=stable
```

#### Install by Metacello (only available in Pharo 7+)

`save-pharo metacello <metacello command-line arguments>`

```bash
REPOS_URL=github://quentinplessis/Teamtalk/pharo-repository
docker run --rm -p 5901:5901 -p 6901:6901 \
	-v=$HOME/docker/pharo/data:/root/data \
	mumez/pharo-vnc-supervisor:pharo70 \
	save-pharo metacello install $REPOS_URL BaselineOfTeamtalk
```

### How to change default Pharo image version 

By default, Pharo 6.1 will be installed to the docker image. You can specify other versions when building a docker image.

```bash
docker build -t pharo70-vnc-supervisor --build-arg PHARO_IMAGE_VERSION=70 .
docker run --name my_pharo70 -d -p 5901:5901 -p 6901:6901 pharo70-vnc-supervisor
```

## Settings

You can change these settings via `docker run` `-e` option.

### Pharo related environment variables

```bash
PHARO_SUPERVISOR_LOG_NAME=pharo-supervisord.log
PHARO_IMAGE=Pharo.image
PHARO_START_SCRIPT=
PHARO_MODE=gui
```

### VNC related environment variables

Please see [ubuntu-icewm-vnc](https://hub.docker.com/r/consol/ubuntu-icewm-vnc/).
