FROM debian:latest
ENV LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 SHELL=/bin/zsh PATH=/usr/local/go/bin:/root/go/bin:$PATH
COPY [ "init.sh", "/" ]
RUN [ "/bin/bash", "/init.sh" ]
WORKDIR /workspace
CMD [ "/bin/sleep", "infinity" ]
