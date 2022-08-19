FROM shynhan/dev-environment:base

ENV PATH=/usr/local/go/bin:/root/go/bin:$PATH

RUN /bin/sh -c set -eux; DEBIAN_FRONTEND=noninteractive; \
  apt-get update && apt-get upgrade -y; \
  wget https://go.dev/dl/go1.19.linux-amd64.tar.gz -O go.tar.gz; \
  rm -rf /usr/local/go && tar -C /usr/local -xzf go.tar.gz && rm go.tar.gz; \
  go install github.com/cweill/gotests/gotests@latest; \
  go install github.com/fatih/gomodifytags@latest; \
  go install github.com/josharian/impl@latest; \
  go install github.com/haya14busa/goplay/cmd/goplay@latest; \
  go install github.com/go-delve/delve/cmd/dlv@latest; \
  go install honnef.co/go/tools/cmd/staticcheck@latest; \
  go install golang.org/x/tools/gopls@latest; \
  go clean -cache -modcache; \
  rm -rf /var/lib/apt/lists/*
