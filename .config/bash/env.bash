# Handles environment variables and PATH deduplication across OSs.

# Environment Variables
export TERM="xterm-256color"
export PYENV_ROOT="$HOME/.pyenv"
export VIRTUAL_ENV_DISABLE_PROMPT=1
export HOMEBREW_NO_AUTO_UPDATE=1
export NVM_DIR="$HOME/.nvm"
export CDPATH=".:$HOME"

# OS Detection
OS_TYPE="$(uname -s)"

# OS-Specific Base Variables
case "$OS_TYPE" in
    Darwin)
        export ANDROID_HOME="$HOME/Library/Android/sdk"
        export PNPM_HOME="$HOME/Library/pnpm"
        ;;
    Linux)
        export ANDROID_HOME="$HOME/Android/Sdk"
        export PNPM_HOME="$HOME/.local/share/pnpm"
        ;;
esac

# PATH Deduplication Helper
add_to_path() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="$1:$PATH"
    fi
}

# Cross-Platform Paths
add_to_path "$HOME/go/bin"
add_to_path "/usr/local/go/bin"
add_to_path "$PNPM_HOME/bin"
add_to_path "$ANDROID_HOME/platform-tools"
add_to_path "$ANDROID_HOME/emulator"
add_to_path "$PYENV_ROOT/bin"
add_to_path "$HOME/.local/bin"

# OS-Specific Paths
case "$OS_TYPE" in
    Darwin)
        add_to_path "/opt/homebrew/opt/postgresql@16/bin"
        add_to_path "/opt/homebrew/opt/openjdk@17/bin"
        add_to_path "/Library/Frameworks/Python.framework/Versions/3.13/bin"
        add_to_path "/opt/homebrew/opt/coreutils/libexec/gnubin"
        add_to_path "/opt/homebrew/bin"
        ;;
    Linux)
        add_to_path "/usr/lib/jvm/default/bin"
        add_to_path "/snap/bin"
        ;;
esac

# Add $HOME/scripts and all subdirectories recursively (Bash 4+)
if [ -d "$HOME/scripts" ]; then
    shopt -s globstar
    for dir in "$HOME/scripts"/**/; do
        add_to_path "${dir%/}"
    done
fi

export PATH

