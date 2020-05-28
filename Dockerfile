# ====================================================================== #
# Android SDK Docker Image
# ====================================================================== #

# Base image
# ---------------------------------------------------------------------- #
FROM alpine:3.11.5

# Author
# ---------------------------------------------------------------------- #
LABEL maintainer "john@kerryhouse.net"

# update ca certs
RUN apk update \
    apk add ca-certificates \
    update-ca-certificates

# install basic dependencies
RUN apk update \
    apk upgrade \
    apk add tar

# download sensuctl
RUN wget https://s3-us-west-2.amazonaws.com/sensu.io/sensu-go/5.19.1/sensu-go_5.19.1_linux_amd64.tar.gz -O /tmp/sensu-go.tar.gz

RUN tar xvf /tmp/sensu-go.tar.gz --directory /usr/bin && \
    rm /tmp/sensu-go.tar.gz

RUN wget https://get.helm.sh/helm-v3.2.0-rc.1-linux-amd64.tar.gz -O /tmp/helm.tar.gz

RUN tar xvf /tmp/helm.tar.gz --directory /tmp && \
    mv /tmp/linux-amd64/helm /usr/bin/. && \
    rm /tmp/helm.tar.gz && \
    rm -rf /tmp/linux-amd64

CMD tail -f /dev/null
