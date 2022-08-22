FROM debian:latest

ENV LANG=en_US.UTF-8 SHELL=/bin/zsh TZ=Asia/Shanghai PATH=/usr/local/go/bin:/root/go/bin:$PATH

RUN /bin/sh -c set -eux; DEBIAN_FRONTEND=noninteractive; \
  apt-get update && apt-get upgrade -y; \
  apt-get install -y --no-install-recommends \
  ca-certificates curl wget netbase gnupg dirmngr procps iputils-ping iproute2 tzdata locales nano sudo \
  git openssh-client zsh g++ gcc libc6-dev make pkg-config python3 python3-pip; \
  localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8; chsh -s $(which zsh); \
  git config --global init.defaultBranch main; \
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended; \
  sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="agnoster"/g' ~/.zshrc; \
  sed -i "s/# zstyle ':omz:update' mode disabled/zstyle ':omz:update' mode disabled/g" ~/.zshrc; \
  echo "zstyle ':omz:update' mode disabled" >> ~/.zshrc; \
  curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && apt-get install -y --no-install-recommends nodejs; \
  npm install -g npm; npm -g cache clean --force; rm /root/.npm/_logs/*.log; \
  wget https://go.dev/dl/go1.19.linux-amd64.tar.gz -O go.tar.gz; \
  rm -rf /usr/local/go && tar -C /usr/local -xzf go.tar.gz && rm go.tar.gz; \
  go install github.com/cweill/gotests/gotests@latest; \
  go install github.com/fatih/gomodifytags@latest; \
  go install github.com/josharian/impl@latest; \
  go install github.com/haya14busa/goplay/cmd/goplay@latest; \
  go install github.com/go-delve/delve/cmd/dlv@latest; \
  go install honnef.co/go/tools/cmd/staticcheck@latest; \
  go install golang.org/x/tools/gopls@latest; \
  go clean -cache -modcache; \
  rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

CMD [ "/bin/sleep", "infinity" ]
