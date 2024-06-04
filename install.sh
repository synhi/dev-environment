#!/usr/bin/env bash
# shellcheck disable=1091
set -eu

function ohmyzsh() {
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" '' --unattended
  {
    echo "# disabled oh-my-zsh update"
    echo "zstyle ':omz:update' mode disabled"
  } >>/root/.zshrc
  chsh -s "$(which zsh)"
}

function python() {
  apt-get install -y python3 python3-pip pipx
  pipx ensurepath
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
  sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b /usr/local/bin
  wget --quiet 'https://raw.githubusercontent.com/go-task/task/main/completion/zsh/_task' \
    -O /usr/local/share/zsh/site-functions/_task
}

# run cmd
"$@"
