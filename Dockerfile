FROM mumez/ubuntu-vnc-supervisor
LABEL maintainer="Masashi Umezawa <ume@softumeya.com>"

## Install prerequisites and utilities
RUN apt-get update && apt-get install -y \
    libssl1.0.0 \
    libaudio2 \
    && rm -rf /var/lib/apt/lists/*

# --------------------
# Pharo
# --------------------
ENV DISPLAY=:0 
ARG PHARO_IMAGE_VERSION=80
ENV PHARO_MODE='gui'
ENV PHARO_IMAGE='Pharo.image'
ARG PHARO_DEFAULT_IMAGE_DIR='/root/data'
ENV PHARO_HOME=${PHARO_DEFAULT_IMAGE_DIR}
ENV PHARO_START_SCRIPT=${PHARO_DEFAULT_IMAGE_DIR}/config/default-startup.st

RUN mkdir pharo && cd pharo \
  && apt-get update && apt-get install -y --no-install-recommends \
    curl \
    unzip \
  && curl https://get.pharo.org/64/${PHARO_IMAGE_VERSION}+vm | bash \
  && mv ../pharo /usr/local/bin/ \
  && apt-get remove -y \
    unzip \
  && rm -rf /var/lib/apt/lists/*

ENV PATH="/usr/local/bin/pharo:${PATH}"

# --------------------
# Setup scripts
# --------------------
ADD ./launch-pharo.sh /usr/local/bin/
ADD ./save-pharo.sh /usr/local/bin/
ADD ./setup.sh /usr/local/bin/
ADD ./docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/*

# --------------------
# Workspace
# --------------------
WORKDIR ${PHARO_DEFAULT_IMAGE_DIR}

RUN cp /usr/local/bin/pharo/Pharo*.* ${PHARO_DEFAULT_IMAGE_DIR}
ADD ./config/default-startup.st ${PHARO_DEFAULT_IMAGE_DIR}/config/

VOLUME [ ${PHARO_DEFAULT_IMAGE_DIR} ]

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