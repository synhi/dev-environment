FROM debian:latest
WORKDIR /root/workspace

COPY --chmod=0744 install.bash /usr/local/bin/

RUN install.bash update

RUN install.bash base

RUN install.bash ohmyzsh
ENV SHELL=/usr/bin/zsh

RUN install.bash python

ARG NODE_MAJOR=20
RUN install.bash nodejs $NODE_MAJOR

ARG GO_VERSION=1.22.3
ENV PATH=/usr/local/go/bin:/root/go/bin:$PATH
RUN install.bash golang $GO_VERSION

RUN install.bash task

RUN install.bash clear
