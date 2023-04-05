FROM debian:latest
COPY [ "dev.sh", "/opt/" ]
RUN [ "/bin/bash", "/opt/dev.sh", "init" ]
# LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8
ENV SHELL=/bin/zsh LANG=en_US.UTF-8 PATH=$PATH:/root/go/bin:/usr/local/go/bin
WORKDIR /root/workspace
CMD [ "/bin/sleep", "infinity" ]
