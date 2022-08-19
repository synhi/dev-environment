FROM debian:latest

RUN /bin/sh -c set -eux; DEBIAN_FRONTEND=noninteractive; \
  apt-get update && apt-get upgrade -y; \
  apt-get install -y --no-install-recommends \
  ca-certificates curl wget netbase gnupg dirmngr procps iputils-ping iproute2 tzdata locales nano sudo \
  git openssh-client zsh g++ gcc libc6-dev make pkg-config python3 python3-pip; \
  localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8; chsh -s $(which zsh); \
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended; \
  sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="agnoster"/g' ~/.zshrc; \
  curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && apt-get install -y nodejs && npm install -g pnpm; \
  rm -rf /var/lib/apt/lists/*

ENV LANG=en_US.UTF-8 SHELL=/bin/zsh TZ=Asia/Shanghai

CMD [ "/bin/sleep", "infinity" ]
