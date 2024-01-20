#!/usr/bin/env bash
# shellcheck disable=1091
set -eu

export DEBIAN_FRONTEND=noninteractive

function clear() {
  rm -rf /var/lib/apt/lists/*
}

function update() {
  apt-get update
  apt-get upgrade -y
  apt-get install -y apt-utils pkg-config dialog locales
  localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
}

function base() {
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
    vim-tiny \
    git \
    build-essential \
    gzip \
    unzip \
    zstd \
    tar \
    bc \
    jq \
    man \
    shfmt \
    shellcheck \
    ;

  git config --global init.defaultBranch main
}

function ohmyzsh() {
  apt-get install -y zsh fonts-powerline
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" '' --unattended
  {
    echo ""
    echo "zstyle ':omz:update' mode disabled" >>/root/.zshrc
  } >>/root/.zshrc
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
  rm -rf /root/.npm
}

function golang() {
  local GO_VERSION=$1
  wget --quiet "https://go.dev/dl/go$GO_VERSION.linux-amd64.tar.gz" -O go.tar.gz
  rm -rf /usr/local/go
  tar -C /usr/local -xzf go.tar.gz
  rm -rf go.tar.gz
}

function task() {
  sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b /usr/local/bin
  wget --quiet 'https://raw.githubusercontent.com/go-task/task/main/completion/zsh/_task' \
    -O /usr/local/share/zsh/site-functions/_task
}

# run cmd
"$@"
