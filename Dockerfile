FROM debian:latest
WORKDIR /root/workspace

COPY --chmod=0744 install.bash /usr/local/bin/

RUN install.bash update
ENV LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8

RUN install.bash base

RUN install.bash ohmyzsh
ENV SHELL=/usr/bin/zsh

RUN install.bash python

ARG NODE_MAJOR=18
RUN install.bash nodejs ${NODE_MAJOR}

ARG GO_VERSION=1.21.1
ENV PATH=/usr/local/go/bin:/root/go/bin:$PATH
RUN install.bash golang ${GO_VERSION}
