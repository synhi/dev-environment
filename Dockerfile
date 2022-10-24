FROM debian:latest
COPY [ "init.sh", "/" ]
RUN [ "/bin/bash", "/init.sh" ]
WORKDIR /workspace
CMD [ "/bin/sleep", "infinity" ]
