FROM debian:latest

COPY --chmod=0744 scripts/init.sh /opt/init.sh
RUN <<EOF
/opt/init.sh && rm /opt/init.sh
EOF

ENV SHELL="/usr/bin/zsh" LANG="en_US.UTF-8"
WORKDIR /root/workspace

COPY --chmod=0744 scripts/install.sh /usr/local/bin/install.sh
COPY --chmod=0644 scripts/.zshenv /root/.zshenv
