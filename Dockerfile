FROM mumez/ubuntu-vnc-supervisor
LABEL maintainer="Masashi Umezawa <ume@softumeya.com>"

# --------------------
# Pharo
# --------------------
ENV DISPLAY=:0 
ARG PHARO_IMAGE_VERSION=140
ENV PHARO_MODE='gui'
ENV PHARO_IMAGE='Pharo.image'
ARG PHARO_DEFAULT_IMAGE_DIR='/root/data'
ENV PHARO_HOME=${PHARO_DEFAULT_IMAGE_DIR}
ENV PHARO_START_SCRIPT=/usr/local/etc/pharo/default-startup.st

## Single RUN: install deps + Pharo, then purge apt cache and temp tools
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  libaudio2 \
  unzip \
  curl \
  && mkdir pharo && cd pharo \
  && curl -fsSL https://get.pharo.org/64/${PHARO_IMAGE_VERSION}+vm | bash \
  && mv ../pharo /usr/local/bin/ \
  && apt-get purge -y --auto-remove unzip \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /root/.cache

ENV PATH="/usr/local/bin/pharo:${PATH}"

# --------------------
# Setup scripts
# --------------------
ADD ./launch-pharo.sh /usr/local/bin/
ADD ./save-pharo.sh /usr/local/bin/
ADD ./setup.sh /usr/local/bin/
ADD ./docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/*

# Kept outside the data volume, so that mounting /root/data does not hide it
ADD ./config/default-startup.st /usr/local/etc/pharo/

# --------------------
# Workspace
# --------------------
WORKDIR ${PHARO_DEFAULT_IMAGE_DIR}

RUN cp /usr/local/bin/pharo/Pharo*.* ${PHARO_DEFAULT_IMAGE_DIR}

VOLUME ${PHARO_DEFAULT_IMAGE_DIR}

EXPOSE 9000

# --------------------
# Supervisor
# --------------------
ENV PHARO_SUPERVISOR_LOG_NAME=pharo-supervisord.log
COPY pharo-supervisord.conf /etc/supervisor/conf.d/pharo-supervisord.conf

# --------------------
# ENTRYPOINT
# --------------------
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["supervisord"]