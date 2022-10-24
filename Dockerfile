FROM debian:latest
COPY [ "init.sh", "/" ]
RUN [ "/bin/bash", "/init.sh" ]
ENV LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8
ENV PATH=$PATH:/root/go/bin:/usr/local/go/bin
WORKDIR /workspace
CMD [ "/bin/sleep", "infinity" ]
