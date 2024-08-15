#!/usr/bin/env bash
set -eu

SHARE_DIR="$HOME/.local/share"
if [[ ! -d $SHARE_DIR ]]; then
  mkdir -p "$SHARE_DIR"
fi

GOPATH="$HOME/.go"
GOROOT="$GOPATH/go"
function golang() {
  local GOVER="$1"
  local GOTAR="/tmp/go.tar.gz"
  local GOCLI="$GOROOT/bin/go"
  local URL="https://go.dev/dl/go${GOVER}.linux-amd64.tar.gz"

  if [[ ! -d "$GOPATH" ]]; then
    mkdir -p "$GOPATH"
  fi

  if [[ -d "$GOROOT" ]]; then
    rm -rf "$GOROOT"
  fi

  wget --quiet "$URL" -O $GOTAR
  tar -C "$GOPATH" -xzf $GOTAR
  rm -rf "$GOTAR"

  $GOCLI version
  $GOCLI env -w GOPATH="$GOPATH"
  $GOCLI env -w GOROOT="$GOROOT"
}

function rust() {
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
}

function python() {
  pyenv update
  pyenv install 3
  pyenv global 3
  python3 -m pip install --user --upgrade pipx
  python3 -m pip cache purge
}

function nodejs() {
  fnm install --lts
  fnm default lts-latest
  fnm list
  echo "fnm uninstall <version> to remove old versions"

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

function neovim() {
  local nvim_url="https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz"
  local nvim_dir="$HOME/.local/share/nvim"
  local nvim_conf="$HOME/.config/nvim"
  local nvim_tar="/tmp/nvim.tar.gz"
  local nvim_tmp="/tmp/nvim-linux64"

  if [[ ! -f "$nvim_tar" ]]; then
    echo "downloading nvim.tar.gz..."
    wget -q -O "$nvim_tar" "$nvim_url"
  fi

  if [[ ! -d "$nvim_tmp" ]]; then
    echo "extract nvim.tar.gz..."
    tar -C /tmp -xzf "$nvim_tar"
  fi

  if [[ ! -d "$nvim_tmp" ]]; then
    echo "failed to extract nvim"
    exit 1
  fi

  if [[ -d "$nvim_dir" ]]; then
    echo "removing old nvim..."
    rm -rf "$nvim_dir"
  fi

  if [[ ! -f "$nvim_conf/init.lua" ]]; then
    echo "creating init.lua..."
    mkdir -p "$nvim_conf"
    touch "$nvim_conf/init.lua"
  fi

  if ! command -v rg &>/dev/null; then
    echo "installing ripgrep..."
    apt-get update
    apt-get install -y ripgrep
  fi

  echo "installing nvim..."
  mv "$nvim_tmp" "$nvim_dir"

  echo "cleaning up..."
  rm "$nvim_tar"
}

# run cmd
"$@"
