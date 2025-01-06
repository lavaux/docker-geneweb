FROM debian:stable-slim AS builder

MAINTAINER Guilhem Lavaux <guilhem.lavaux@gmail.com>

ARG V=geneweb-linux-88536ed4.zip
ARG S6_OVERLAY_RELEASE=https://github.com/just-containers/s6-overlay/releases/latest/download/s6-overlay-x86_64.tar.xz

RUN export DEBIAN_FRONTEND=noninteractive && \
  apt-get update && \
  apt-get -y install --no-install-recommends unzip xz-utils tar && \
  rm -fr /var/lib/apt/lists/*



# Copy script to local bin folder
#COPY bin/*.sh /usr/local/bin/

ADD https://github.com/geneweb/geneweb/releases/download/v7.0.0/$V /app/dist.zip
ADD ${S6_OVERLAY_RELEASE} /tmp/s6overlay.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/latest/download/s6-overlay-noarch.tar.xz /tmp/s6overlay-noarch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/latest/download/s6-overlay-symlinks-arch.tar.xz /tmp/s6overlay-symlinks.tar.xz
RUN mkdir /overlay && tar -xJf /tmp/s6overlay.tar.xz -C /overlay \
    && rm /tmp/s6overlay.tar.xz && \
    tar -xJf /tmp/s6overlay-noarch.tar.xz -C /overlay \
    && rm /tmp/s6overlay-noarch.tar.xz && \
    tar -xJf /tmp/s6overlay-symlinks.tar.xz -C /overlay \
    && rm /tmp/s6overlay-symlinks.tar.xz

RUN unzip -d /app /app/dist.zip && mv /app/distribution/* /app && rmdir /app/distribution && rm -f /app/dist.zip

# Make script executable
#RUN chmod a+x /usr/local/bin/*.sh

FROM debian:stable-slim

# Default language to be English
ENV GENEWEB_LANG en
ENV GENEWEB_HOME /app
ENV GENEWEB_DATA_PATH /app/bases/
ENV GWSETUP_IP 172.17.0.1
ENV GENEWEB_DB database
ENV GENEWEB_DB_PATH /app/bases/
#ENV GENEWEB_ADMIN=${GENEWEB_ADMIN:=admin}
#ENV GENEWEB_ADMIN_PASS=${GENEWEB_ADMIN_PASS:=$(openssl rand -hex 32)}
ENV GENEWEB_LANG en

COPY --from=builder /app /app
COPY --from=builder /overlay /

RUN useradd -b /app -M geneweb && chown -R geneweb /app

ADD rootfs /

WORKDIR /app

# Create a volume on the container
VOLUME /app/bases

# Expose the geneweb and gwsetup ports to the docker host
EXPOSE 2317
EXPOSE 2316

# Run the container as the geneweb user
USER geneweb

ENTRYPOINT ["/init"]
