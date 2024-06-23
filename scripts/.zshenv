# local
export PATH="$HOME/.local/bin:$PATH"

# golang
GOPATH="$HOME/.go"
GOROOT="$GOPATH/go"
if [[ -d "$GOPATH" ]] && [[ -d "$GOROOT" ]]; then
  export PATH="$GOPATH/bin:$GOROOT/bin:$PATH"
fi

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
if [[ -d "$PYENV_ROOT/bin" ]]; then
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
  # eval "$(pyenv virtualenv-init -)"
fi

# fnm
FNM_PATH="$HOME/.local/share/fnm"
if [[ -d "$FNM_PATH" ]]; then
  export PATH="$FNM_PATH:$PATH"
  eval "$(fnm env)"
fi

# nvim
NVIM_PATH="$HOME/.local/share/nvim"
if [[ -d "$NVIM_PATH" ]]; then
  export PATH="$NVIM_PATH/bin:$PATH"
fi

# rust
CARGO_PATH="$HOME/.cargo"
if [[ -d "$CARGO_PATH" ]]; then
  . "$HOME/.cargo/env"
fi
