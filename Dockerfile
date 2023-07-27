FROM debian:latest

RUN DEBIAN_FRONTEND=noninteractive; \
  set -eu; \
  apt-get update; \
  apt-get upgrade -y; \
  apt-get install -y \
  pkg-config \
  apt-utils \
  dialog \
  locales \
  ; \
  localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8; \
  rm -rf /var/lib/apt/lists/*

ENV LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

RUN DEBIAN_FRONTEND=noninteractive; \
  set -eu; \
  apt-get update; \
  apt-get install -y \
  ca-certificates \
  netbase \
  gnupg \
  procps \
  iputils-ping \
  iproute2 \
  openssh-client \
  sudo \
  curl \
  wget \
  nano \
  git \
  build-essential \
  bc \
  jq \
  ; \
  rm -rf /var/lib/apt/lists/*

RUN set -eu; \
  git config --global init.defaultBranch main; \
  mkdir -p /workspace/.vscode-server; \
  ln -s /workspace/.vscode-server /root/.vscode-server

WORKDIR /workspace

CMD [ "/bin/sleep", "infinity" ]

# install python
RUN DEBIAN_FRONTEND=noninteractive; \
  set -eu; \
  apt-get update; \
  apt-get install -y python3 python3-pip; \
  rm -rf /var/lib/apt/lists/*

# install php
# RUN DEBIAN_FRONTEND=noninteractive; \
#   set -eu; \
#   apt-get update; \
#   apt-get install -y php-cli php-pear; \
#   php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"; \
#   php composer-setup.php; \
#   php -r "unlink('composer-setup.php');"; \
#   mv composer.phar /usr/local/bin/composer; \
#   rm -rf /var/lib/apt/lists/*

# install zsh and ohmyzsh
RUN DEBIAN_FRONTEND=noninteractive; \
  set -eu; \
  apt-get update; \
  apt-get install -y zsh fonts-powerline; \
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" '' --unattended; \
  sed -i 's@ZSH_THEME="robbyrussell"@ZSH_THEME="agnoster"@g' /root/.zshrc; \
  echo "" >>/root/.zshrc ;\
  echo "zstyle ':omz:update' mode disabled" >>/root/.zshrc ;\
  echo "alias task-update='sh -c \"\$(curl --location https://taskfile.dev/install.sh)\" -- -d -b /workspace/.go/bin'" >>/root/.zshrc ;\
  chsh -s "$(which zsh)"; \
  rm -rf /var/lib/apt/lists/*

# install nodejs
RUN DEBIAN_FRONTEND=noninteractive; \
  set -eu; \
  curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -; \
  apt-get update; \
  apt-get install -y nodejs; \
  npm remove -g corepack; \
  npm install -g npm pnpm; \
  npm -g cache clean --force; \
  rm -rf /root/.npm; \
  rm -rf /var/lib/apt/lists/*

# install golang
ENV PATH=/usr/local/go/bin:/workspace/.go/bin:$PATH
RUN set -eu; \
  wget --quiet 'https://go.dev/dl/go1.20.6.linux-amd64.tar.gz' -O go.tar.gz; \
  tar -C /usr/local -xzf go.tar.gz; \
  mkdir -p /workspace/.go; \
  go env -w GOPATH=/workspace/.go; \
  rm -rf go.tar.gz
