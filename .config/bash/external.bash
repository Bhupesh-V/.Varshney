# Third-party initializations (Homebrew, Completions, FZF, Lazy NVM, Kubectl).

# Homebrew environment
if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Bash programmable completions
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    elif [ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]; then
        . "/opt/homebrew/etc/profile.d/bash_completion.sh"
    fi
fi

# FZF fuzzy finder initialization
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -f "$HOME/fzf-docker/docker-fzf" ] && source "$HOME/fzf-docker/docker-fzf"
command -v fzf &>/dev/null && eval "$(fzf --bash)"

# Lazy-load NVM on first use (prevents startup lag)
_load_nvm() {
    unset -f nvm node npm pnpm
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}

nvm()  { _load_nvm; nvm "$@"; }
node() { _load_nvm; node "$@"; }
npm()  { _load_nvm; npm "$@"; }
pnpm() { _load_nvm; pnpm "$@"; }

# Kubectl completions
if command -v kubectl &>/dev/null; then
    source <(kubectl completion bash)
    complete -F __start_kubectl k
fi