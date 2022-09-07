FROM debian:latest
COPY [ "init.sh", "/" ]
RUN [ "/bin/bash", "/init.sh" ]
ENV LANG=en_US.UTF-8 SHELL=/bin/zsh TZ=Asia/Shanghai PATH=/usr/local/go/bin:/root/go/bin:$PATH
WORKDIR /workspace
CMD [ "/bin/sleep", "infinity" ]
