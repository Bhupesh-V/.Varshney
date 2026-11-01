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
export FZF_COMPLETION_TRIGGER=''
if command -v fzf &>/dev/null; then
    eval "$(fzf --bash)"

    # Only pop the fzf picker when a path is actually ambiguous; if the
    # current word already resolves to exactly one file/dir, complete it
    # directly like plain bash completion would.
    _fzf_smart_dispatch() {
        local real_fn=$1 cur expanded matches m
        shift
        cur="${COMP_WORDS[COMP_CWORD]}"
        if [[ $cur != *'$('* && $cur != *':='* && $cur != *'`'* ]]; then
            eval "expanded=$cur" 2>/dev/null || expanded=$cur
            mapfile -t matches < <(compgen -f -- "$expanded" 2>/dev/null)
            if [[ ${#matches[@]} -eq 1 ]]; then
                m=${matches[0]}
                [[ -d $m ]] && m+="/"
                COMPREPLY=("$m")
                return 0
            fi
        fi
        "$real_fn" "$@"
    }
    _fzf_smart_default_completion() { _fzf_smart_dispatch __fzf_default_completion "$@"; }
    _fzf_smart_path_completion()    { _fzf_smart_dispatch _fzf_path_completion "$@"; }
    _fzf_smart_dir_completion()     { _fzf_smart_dispatch _fzf_dir_completion "$@"; }

    complete -D -F _fzf_smart_default_completion -o default -o bashdefault 2>/dev/null

    while read -r _cmd; do
        complete -F _fzf_smart_path_completion -o default -o bashdefault "$_cmd" 2>/dev/null
    done < <(complete -p 2>/dev/null | grep -- '-F _fzf_path_completion ' | awk '{print $NF}')

    while read -r _cmd; do
        complete -F _fzf_smart_dir_completion -o bashdefault -o nospace -o dirnames "$_cmd" 2>/dev/null
    done < <(complete -p 2>/dev/null | grep -- '-F _fzf_dir_completion ' | awk '{print $NF}')
    unset _cmd
fi

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