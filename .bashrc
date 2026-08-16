# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return ;;
esac

BASH_CONFIG_DIR="$HOME/.config/bash"

config_modules=(
    "env.bash"
    "options.bash"
    "prompt.bash"
    "external.bash"
)

# Guard clause: log error and exit if config directory is missing
if [ ! -d "$BASH_CONFIG_DIR" ]; then
    echo "[bashrc ERROR] Config directory missing: $BASH_CONFIG_DIR" >&2
    return 1
fi

# Source modules in defined sequence
for module in "${config_modules[@]}"; do
    file="$BASH_CONFIG_DIR/$module"

    # Guard clause: log warning and skip if file is unreadable
    if [ ! -r "$file" ]; then
        echo "[bashrc WARN] Skipping missing or unreadable module: $module ($file)" >&2
        continue
    fi

    source "$file"
done

# Source standard standalone dotfiles
[ -f ~/.bash_functions ] && source ~/.bash_functions
[ -f ~/.bash_aliases ]   && source ~/.bash_aliases

unset BASH_CONFIG_DIR config_modules module file