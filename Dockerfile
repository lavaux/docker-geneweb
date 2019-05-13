FROM ubuntu:19.04

MAINTAINER Jeffery Fernandez <jefferyfernandez@gmail.com>

RUN \
  apt-get update && \
  apt-get -y install --no-install-recommends geneweb gwsetup tzdata && \
  rm -fr /var/lib/apt/lists/*

# The database path and home directory of geneweb
ENV GENEWEB_HOME /usr/local/var/geneweb

# Default language to be English
ENV LANGUAGE en

# Default access to gwsetup is from docker host
ENV HOST_IP 172.17.0.1

# Copy script to local bin folder
COPY bin/*.sh /usr/local/bin/

# Make script executable
RUN chmod a+x /usr/local/bin/*.sh

# Share the local volume onto the container
VOLUME ${GENEWEB_HOME}

# Change the geneweb home directory to our database path to avoid stomping on debian package path /var/lib/geneweb
RUN usermod -d ${GENEWEB_HOME} geneweb

# Expose the geneweb and gwsetup ports to the docker host
EXPOSE 2317
EXPOSE 2316

# Run the container as the geneweb user
USER geneweb

ENTRYPOINT ["main.sh"]
CMD ["start-all"]

