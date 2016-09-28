FROM alpine:3.4
MAINTAINER Volker Machon <volker@machon.biz>

ARG JPEGOPTIM_VERSION=1.4.4

RUN apk --update add \
           alpine-sdk \
           ca-certificates \
           libjpeg-turbo \
           libjpeg-turbo-dev \
           tar \
           wget \
      && mkdir -p /usr/src/jpegoptim /source \
      && wget -O - https://github.com/tjko/jpegoptim/archive/RELEASE.${JPEGOPTIM_VERSION}.tar.gz | tar xz -C /usr/src/jpegoptim --strip-components=1 \
      && cd /usr/src/jpegoptim \
      && ./configure \
      && make \
      && make strip \
      && make install \
      && rm -rf /usr/src/jpegoptim \
      && apk del \
           alpine-sdk \
           ca-certificates \
           libjpeg-turbo-dev \
           tar \
           wget \
      && rm -rf /var/cache/apk/*

VOLUME ["/source"]
WORKDIR /source
ENTRYPOINT ["/usr/local/bin/jpegoptim"]
CMD ["--quiet", "--strip-all", "--preserve-perms", "*.jpg"]
