#!/bin/bash
# shellcheck disable=SC2155
set -eu
export DEBIAN_FRONTEND=noninteractive

function install_base() {
  apt-get update
  apt-get upgrade -y
  apt-get install -y \
    apt-utils \
    pkg-config \
    dialog \
    man \
    locales

  # localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
  echo 'en_US.UTF-8 UTF-8' >/etc/locale.gen
  locale-gen
  export LANG=en_US.UTF-8
}

function install_tools() {
  apt-get install -y \
    sudo \
    procps \
    netbase \
    iproute2 \
    iputils-ping \
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

  # set git default branch
  git config --global init.defaultBranch main
}

function install_python_deps() {
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
}

function install_ohmyzsh() {
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" '' --unattended
  chsh -s "$(which zsh)"
  cat >/root/.zshrc <<'EOF'

# config
zstyle ":omz:update" mode disabled
export PATH="$HOME/.local/bin:$PATH"

# golang
export GOPATH="$HOME/.go"
export GOROOT="$GOPATH/go"
export PATH="$GOPATH/bin:$GOROOT/bin:$PATH"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
if [[ -d $PYENV_ROOT/bin ]]; then
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
  # eval "$(pyenv virtualenv-init -)"
fi

# fnm
FNM_PATH="/root/.local/share/fnm"
if [[ -d "$FNM_PATH" ]]; then
  export PATH="/root/.local/share/fnm:$PATH"
  eval "$(fnm env)"
fi

EOF
}

function install_fnm() {
  curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell
}

function install_pyenv() {
  curl https://pyenv.run | bash
}

install_base
install_tools
install_python_deps
install_ohmyzsh
install_fnm

# clean up
rm -rf /var/lib/apt/lists/*
