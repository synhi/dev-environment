#!/usr/bin/env bash
# shellcheck disable=1091
set -eu

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
  curl https://pyenv.run | bash

  {
    echo 'export PYENV_ROOT="$HOME/.pyenv"'
    echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"'
    echo 'eval "$(pyenv init -)"'
    echo '# eval "$(pyenv virtualenv-init -)"'
  } >>/root/.zshrc

  source /root/.zshrc
  pyenv install 3
  pyenv global 3
  python3 -m pip install --user pipx
  pipx install poetry
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
  source /root/.zshrc
  fnm use --install-if-missing 20
  npm rm -g corepack
  npm install -g pnpm
  # rm -rf /root/.npm
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
