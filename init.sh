#!/usr/bin/env bash
set -eu

export DEBIAN_FRONTEND=noninteractive

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
  tar \
  zstd \
  gzip \
  unzip \
  tzdata \
  locales

localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

apt-get install -y \
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

# python build dependencies
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

rm -rf /var/lib/apt/lists/*

git config --global init.defaultBranch main
