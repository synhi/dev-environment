#!/bin/bash
set -eu

export DEBIAN_FRONTEND=noninteractive

clean() {
  rm -rf /var/lib/apt/lists/*
}

add() {
  apt-get install -y --no-install-recommends $@
}

base() {
  apt-get update && apt-get upgrade -y
  apt-get install -y apt-utils dialog locales
  apt-get install -y ca-certificates procps iputils-ping iproute2 sudo openssh-client zsh pkg-config
  apt-get install -y curl wget nano git build-essential # netbase gnupg dirmngr

  localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
  git config --global init.defaultBranch main
}

backup_root() {
  cp -rf /root /opt/
}

recovery_root() {
  cp -rf /opt/root /
}

install_omz() {
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  sed -i "s/# zstyle ':omz:update' mode disabled/zstyle ':omz:update' mode disabled/g" ~/.zshrc
  # sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="agnoster"/g' ~/.zshrc
  chsh -s $(which zsh)
}

install_python() {
  apt-get install -y python3 python3-pip
}

install_php() {
  apt-get install -y php-cli php-pear
  php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
  php composer-setup.php
  php -r "unlink('composer-setup.php');"
  mv composer.phar /usr/local/bin/composer
}

install_nodejs() {
  curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && apt-get install -y nodejs
  npm remove -g corepack
  npm install -g pnpm
  npm -g cache clean --force
  rm -rf /root/.npm/_logs/*.log
}

install_go() {
  wget --quiet "$1" -O go.tar.gz
  tar -C /usr/local -xzf go.tar.gz
  rm go.tar.gz
}

update_go() {
  rm -rf /usr/go
  install_go "$1"
}

init() {
  base
  install_go 'https://go.dev/dl/go1.20.1.linux-amd64.tar.gz'
  install_nodejs
  # install_python
  # install_php

  backup_root
  clean
}

"$@"
