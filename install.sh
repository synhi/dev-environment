#!/usr/bin/env bash
# shellcheck disable=2016
set -eu

function golang() {
  local GOVER="$1"
  local GOTAR="/tmp/go.tar.gz"
  local URL="https://go.dev/dl/go${GOVER}.linux-amd64.tar.gz"

  mkdir -p "$GOPATH"
  rm -rf "$GOROOT"

  wget --quiet "$URL" -O $GOTAR
  tar -C "$GOPATH" -xzf $GOTAR

  go version

  rm -rf "$GOTAR"
}

function python() {
  pyenv install 3
  pyenv global 3
  python -m pip install --user --upgrade pipx
  python -m pip cache purge
}

function nodejs() {
  fnm use --install-if-missing 20
  npm rm -g corepack
  npm install -g pnpm
}

function php() {
  apt-get update
  apt-get install -y php-cli php-pear
  php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
  php composer-setup.php
  php -r "unlink('composer-setup.php');"
  mv composer.phar /usr/local/bin/composer
}

function task() {
  local DES_DIR="$HOME/.oh-my-zsh/custom/plugins/task"
  mkdir -p "$DES_DIR"

  sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b "$GOPATH/bin"
  wget --quiet 'https://raw.githubusercontent.com/go-task/task/main/completion/zsh/_task' \
    -O "$DES_DIR/_task"

  echo "add 'task' to plugins in .zshrc"
}

# run cmd
"$@"
