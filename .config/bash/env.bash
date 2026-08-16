# Handles environment variables and PATH deduplication.

# Environment Variables
export TERM="xterm-256color"
export PYENV_ROOT="$HOME/.pyenv"
export VIRTUAL_ENV_DISABLE_PROMPT=1
export HOMEBREW_NO_AUTO_UPDATE=1
export ANDROID_HOME="$HOME/Library/Android/sdk"
export PNPM_HOME="$HOME/Library/pnpm"
export NVM_DIR="$HOME/.nvm"
export CDPATH=".:/home/bhupesh"

# PATH Deduplication Helper
add_to_path() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="$1:$PATH"
    fi
}

# Add directories to PATH in priority order (lowest to highest)
add_to_path "$HOME/go/bin"
add_to_path "/usr/local/go/bin"
add_to_path "$PNPM_HOME/bin"
add_to_path "$ANDROID_HOME/platform-tools"
add_to_path "$ANDROID_HOME/emulator"
add_to_path "/opt/homebrew/opt/postgresql@16/bin"
add_to_path "/opt/homebrew/opt/openjdk@17/bin"
add_to_path "/Library/Frameworks/Python.framework/Versions/3.13/bin"
add_to_path "/opt/homebrew/opt/coreutils/libexec/gnubin"
add_to_path "/opt/homebrew/bin"
add_to_path "$PYENV_ROOT/bin"
add_to_path "$HOME/.local/bin"
add_to_path "$HOME/scripts/media"
add_to_path "$HOME/scripts/aws"
add_to_path "$HOME/scripts/github"
add_to_path "$HOME/scripts/git"
add_to_path "$HOME/scripts"

export PATH