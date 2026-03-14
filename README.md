# pharo-vnc-supervisor

A Docker image for [Pharo Smalltalk](http://www.pharo-project.org/ "Pharo"). Especially suitable for web application development and delivery.

- Pharo process is daemonized by supervisord.
- Debuggable via VNC.

## Usages

```bash
docker run --name my_pharo -d -p 5900:5900 -p 6901:6901 mumez/pharo-vnc-supervisor
```

You can access the running pharo image via VNC client or web browser.
(the default password is 'vncpassword')

- VNC client: `yourhost:5900`
- Web browser: `http://yourhost:6901/?password=vncpassword`

### How to start with a customized Pharo image

1. Place your customized Pharo image to your docker-host data directory (For example, `$HOME/docker/pharo/data`).
2. Use `docker run` `-v` option to mount the data direcotry.

```bash
docker run --name my_pharo -d -p 5900:5900 -p 6901:6901 \
	-v=$HOME/docker/pharo/data:/root/data \
	mumez/pharo-vnc-supervisor
```

> **Note for Windows (Git Bash / MSYS):** The colon in `:/root/data` can be mangled by the shell, so the host directory may not mount correctly. Use one of these:
>
> - Prevent path conversion: `MSYS_NO_PATHCONV=1 docker run ... -v /c/Users/YourUser/docker/pharo/data:/root/data ...`
> - Or use a Windows-style path: `-v C:/Users/YourUser/docker/pharo/data:/root/data`

### How to build a customized Pharo image in a container

You can use `save-pharo` command to build a customized Pharo image.

#### Install by Metacello

`save-pharo metacello <metacello command-line arguments>`

```bash
REPOS_URL=github://mumez/PharoSmalltalkInteropServer:main/src
# On Windows (Git Bash), use: MSYS_NO_PATHCONV=1 docker run ... -v /c/Users/ume/docker/pharo/data:/root/data ...
docker run --rm -p 5900:5900 -p 6901:6901 \
	-v=$HOME/docker/pharo/data:/root/data \
	mumez/pharo-vnc-supervisor \
	save-pharo metacello install $REPOS_URL BaselineOfPharoSmalltalkInteropServer
```

#### Install by Configuration

`save-pharo config <Metacello configuration>`

```bash
docker run --rm -p 5900:5900 -p 6901:6901 \
	-v=$HOME/docker/pharo/data:/root/data \
	mumez/pharo-vnc-supervisor \
	save-pharo config http://smalltalkhub.com/mc/Pharo/MetaRepoForPharo60/main/ \
	ConfigurationOfNeo4reSt --install=stable
```

### How to change default Pharo image version

By default, Pharo 13.0 will be installed to the docker image. You can specify other versions when building a docker image.

```bash
docker build -t pharo140-vnc-supervisor --build-arg PHARO_IMAGE_VERSION=140 .
docker run --name my_pharo140 -d -p 5900:5900 -p 6901:6901 pharo140-vnc-supervisor
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

Please see [ubuntu-vnc-supervisor](https://github.com/mumez/ubuntu-vnc-supervisor).
