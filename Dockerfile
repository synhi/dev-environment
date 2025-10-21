FROM debian:latest

# Copy Docker CLI
COPY --from=docker:cli /usr/local/bin/docker /usr/local/bin/docker
COPY --from=docker:cli /usr/local/libexec/docker/cli-plugins/ /usr/local/libexec/docker/cli-plugins/
# Copy Shell Script
COPY --chmod=0744 scripts/init.sh /opt/init.sh
COPY --chmod=0744 scripts/install.sh /usr/local/bin/install.sh
COPY --chmod=0644 scripts/.zshenv /root/.zshenv

# Run Intialization Script
RUN <<EOF
/opt/init.sh && rm /opt/init.sh
EOF

ENV SHELL="/usr/bin/zsh" LANG="en_US.UTF-8"

WORKDIR /root
