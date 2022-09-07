#!/bin/bash
set -eux
DEBIAN_FRONTEND=noninteractive

function add() {
  apt-get install -y --no-install-recommends $@
}

function clean() {
  rm -rf /var/lib/apt/lists/*
  rm $1
}

function base() {
  apt-get update && apt-get upgrade -y
  add locales tzdata ca-certificates curl wget netbase gnupg dirmngr procps iputils-ping iproute2 nano sudo git openssh-client
  localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
  git config --global init.defaultBranch main
}

function install_zsh() {
  add zsh
  chsh -s $(which zsh)
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="agnoster"/g' ~/.zshrc
  sed -i "s/# zstyle ':omz:update' mode disabled/zstyle ':omz:update' mode disabled/g" ~/.zshrc
  echo "zstyle ':omz:update' mode disabled" >>~/.zshrc
}

function install_python() {
  add python3 python3-pip
}

function install_nodejs() {
  curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && apt-get install -y --no-install-recommends nodejs
  npm install -g npm pnpm
  npm -g cache clean --force
  rm /root/.npm/_logs/*.log
}

function install_go() {
  add g++ gcc libc6-dev make pkg-config
  wget $1 -O go.tar.gz
  rm -rf /usr/local/go && tar -C /usr/local -xzf go.tar.gz && rm go.tar.gz
  export PAHT=/usr/local/go/bin:/root/go/bin:$PATH
  go install github.com/cweill/gotests/gotests@latest
  go install github.com/fatih/gomodifytags@latest
  go install github.com/josharian/impl@latest
  go install github.com/haya14busa/goplay/cmd/goplay@latest
  go install github.com/go-delve/delve/cmd/dlv@latest
  go install honnef.co/go/tools/cmd/staticcheck@latest
  go install golang.org/x/tools/gopls@latest
  go clean -cache -modcache
}

base
install_zsh
install_python
install_nodejs
install_go https://go.dev/dl/go1.19.1.linux-amd64.tar.gz

clean $0
