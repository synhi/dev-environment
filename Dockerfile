FROM debian:latest

COPY --chmod=0744 init.sh /tmp/init.sh
RUN /tmp/init.sh && rm /tmp/init.sh

ENV SHELL="/usr/bin/zsh" LANG="en_US.UTF-8"
WORKDIR /root/workspace

COPY --chmod=0744 install.sh /usr/local/bin/install.sh
