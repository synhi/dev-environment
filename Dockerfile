FROM debian:latest

CMD ["/bin/sleep" "infinity"]

RUN /bin/sh -c set -eux; DEBIAN_FRONTEND=noninteractive; \
  apt-get update && apt-get upgrade -y; \
  apt-get install -y --no-install-recommends \
    ca-certificates curl wget netbase gnupg dirmngr procps iputils-ping iproute2 tzdata locales nano sudo \
    git openssh-client zsh g++ gcc libc6-dev make pkg-config python3 python3-pip; \
  localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8; \
  chsh -s $(which zsh); \
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended; \
  curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && apt-get install -y nodejs; \
  npm install -g pnpm; \
  wget https://go.dev/dl/go1.19.linux-amd64.tar.gz -O go.tar.gz; \
  rm -rf /usr/local/go && tar -C /usr/local -xzf go.tar.gz && rm go.tar.gz; \
  rm -rf /var/lib/apt/lists/*

ENV PATH=/usr/local/go/bin:/root/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
