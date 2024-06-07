FROM debian:latest

COPY --chmod=0744 init.sh /opt/init.sh
RUN /opt/init.sh && rm /opt/init.sh

ENV SHELL="/usr/bin/zsh" LANG="en_US.UTF-8"
WORKDIR /root/workspace

COPY --chmod=0744 install.sh /usr/local/bin/install.sh
