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
  shellcheck \
  ;

rm -rf /var/lib/apt/lists/*

git config --global init.defaultBranch main
