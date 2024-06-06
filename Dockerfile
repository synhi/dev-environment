FROM debian:latest

COPY --chmod=0744 install.sh /usr/local/bin/install.sh

RUN install.sh init

WORKDIR /root/workspace

ENV SHELL=/usr/bin/zsh LANG=en_US.UTF-8
