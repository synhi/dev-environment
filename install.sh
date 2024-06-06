#!/usr/bin/env bash
# shellcheck disable=2016
set -eu
shopt -s expand_aliases
alias zsh="zsh -i -l"

function init() {
  export DEBIAN_FRONTEND=noninteractive

  # update apt
  apt-get update
  apt-get upgrade -y
  apt-get install -y \
    apt-utils \
    pkg-config \
    dialog \
    sudo \
    man \
    procps \
    netbase \
    iproute2 \
    iputils-ping \
    locales

  # localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
  echo 'en_US.UTF-8 UTF-8' >/etc/locale.gen
  locale-gen

  export LANG=en_US.UTF-8

  # install basic tools
  apt-get install -y \
    tar \
    zstd \
    gzip \
    unzip \
    tzdata \
    build-essential \
    ca-certificates \
    openssh-client \
    gnupg \
    curl \
    wget \
    ncat \
    zsh \
    fonts-powerline \
    vim-tiny \
    git \
    bc \
    jq \
    shfmt \
    shellcheck

  rm -rf /var/lib/apt/lists/*

  git config --global init.defaultBranch main
}

function ohmyzsh() {
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" '' --unattended
  {
    echo "# disabled oh-my-zsh update"
    echo 'zstyle ":omz:update" mode disabled'
    echo 'export PATH="$HOME/.local/bin:$PATH"'
  } >>/root/.zshrc
  chsh -s "$(which zsh)"
}

function python() {
  # python build dependencies
  apt-get update
  apt-get install -y \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libxml2-dev \
    libxmlsec1-dev \
    libffi-dev \
    liblzma-dev

  curl https://pyenv.run | bash

  {
    echo 'export PYENV_ROOT="$HOME/.pyenv"'
    echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"'
    echo 'eval "$(pyenv init -)"'
    echo '# eval "$(pyenv virtualenv-init -)"'
  } >>/root/.zshrc

  zsh -c 'pyenv install 3'
  zsh -c 'pyenv global 3'
  zsh -c 'python3 -m pip install --user pipx'
  zsh -c 'pipx install poetry'
  zsh -c 'pip cache purge'
}

function php() {
  apt-get update
  apt-get install -y php-cli php-pear
  php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
  php composer-setup.php
  php -r "unlink('composer-setup.php');"
  mv composer.phar /usr/local/bin/composer
}

function nodejs() {
  curl -fsSL https://fnm.vercel.app/install | bash
  zsh -c 'fnm use --install-if-missing 20'
  zsh -c 'npm rm -g corepack'
  zsh -c 'npm install -g pnpm'
}

function golang() {
  local GO_VERSION="$1"
  local GO_TMP="/tmp/go.tar.gz"
  local GO_DES="$HOME/.go"
  local GO_DIR="$GO_DES/go"

  wget --quiet "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz" -O $GO_TMP
  mkdir -p "$GO_DES"
  rm -rf "$GO_DIR"
  tar -C "$GO_DES" -xzf $GO_TMP
  rm -rf "$GO_TMP"

  if type go >/dev/null 2>&1; then
    return
  fi

  {
    echo "export GOPATH=\$HOME/.go"
    echo "export PATH=\$PATH:\$GOPATH/bin:$GO_DIR/bin"
  } >>/root/.zshrc
}

function task() {
  local DES_DIR="$HOME/.oh-my-zsh/custom/plugins/task"
  mkdir -p "$DES_DIR"

  sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b "$HOME/.go/bin"
  wget --quiet 'https://raw.githubusercontent.com/go-task/task/main/completion/zsh/_task' \
    -O "$DES_DIR/_task"
}

# run cmd
"$@"
