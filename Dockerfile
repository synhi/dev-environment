FROM debian:latest

WORKDIR /root/workspace

COPY --chmod=0744 install.sh /usr/local/bin/install.sh

COPY --chmod=0744 init.sh /tmp/init.sh

RUN /tmp/init.sh && rm /tmp/init.sh
