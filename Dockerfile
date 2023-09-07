FROM debian:latest

WORKDIR /workspace

CMD [ "/bin/sleep", "infinity" ]

COPY --chmod=0744 install.bash /usr/local/bin/

ARG NODE_MAJOR=18
ARG GO_VERSION=1.21.1

RUN install.bash base \
  && install.bash ohmyzsh \
  && install.bash nodejs ${NODE_MAJOR} \
  && install.bash golang ${GO_VERSION} \
  && install.bash clear
