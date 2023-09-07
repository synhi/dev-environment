#!/usr/bin/env bash
set -eu

export DEBIAN_FRONTEND=noninteractive

function clear() {
  rm -rf /var/lib/apt/lists/*
}

function base() {
  apt-get update
  apt-get upgrade -y
  apt-get install -y apt-utils pkg-config dialog locales

  localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

  export LANGUAGE=en_US.UTF-8
  export LC_ALL=en_US.UTF-8
  export LANG=en_US.UTF-8

  apt-get install -y \
    ca-certificates \
    netbase \
    gnupg \
    procps \
    iputils-ping \
    iproute2 \
    openssh-client \
    sudo \
    curl \
    wget \
    nano \
    git \
    build-essential \
    bc \
    jq \
    ;

  git config --global init.defaultBranch main
  mkdir -p /workspace/.vscode-server
  ln -s /workspace/.vscode-server /root/.vscode-server
  {
    echo 'LANGUAGE="en_US.UTF-8"'
    echo 'LC_ALL="en_US.UTF-8"'
    echo 'LANG="en_US.UTF-8"'
    # echo 'SHELL="/usr/bin/zsh"'
  } >>/etc/environment
}

function ohmyzsh() {
  apt-get install -y zsh fonts-powerline
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" '' --unattended
  {
    echo ""
    echo "zstyle ':omz:update' mode disabled" >>/root/.zshrc
  } >>/root/.zshrc
  wget --quiet 'https://raw.githubusercontent.com/go-task/task/main/completion/zsh/_task' -O /usr/local/share/zsh/site-functions/_task
  # sed -i 's@ZSH_THEME="robbyrussell"@ZSH_THEME="agnoster"@g' /root/.zshrc; \
  chsh -s "$(which zsh)"
}

function python() {
  apt-get install -y python3 python3-pip
}

function php() {
  apt-get install -y php-cli php-pear
  php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
  php composer-setup.php
  php -r "unlink('composer-setup.php');"
  mv composer.phar /usr/local/bin/composer
}

function nodejs() {
  local NODE_MAJOR=$1
  curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key |
    gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
  echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" |
    tee /etc/apt/sources.list.d/nodesource.list
  apt-get update
  apt-get install -y nodejs
  npm remove -g corepack
  npm install -g npm pnpm
  npm -g cache clean --force
  rm -rf /root/.npm
}

function golang() {
  local GO_VERSION=$1
  wget --quiet "https://go.dev/dl/go$GO_VERSION.linux-amd64.tar.gz" -O go.tar.gz
  tar -C /usr/local -xzf go.tar.gz
  rm -rf go.tar.gz
  mkdir -p /workspace/.go
  go env -w GOPATH=/workspace/.go
}

function task() {
  mkdir -p /workspace/.go/bin
  sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b /workspace/.go/bin
}

# run cmd
"$@"
