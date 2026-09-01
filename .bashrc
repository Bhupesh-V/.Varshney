BASH_CONFIG_DIR="$HOME/.config/bash"

# Guard clause: log error and exit if config directory is missing
if [ ! -d "$BASH_CONFIG_DIR" ]; then
    echo "[bashrc ERROR] Config directory missing: $BASH_CONFIG_DIR" >&2
    return 1
fi

# Load general environment configurations first
if [ -r "$BASH_CONFIG_DIR/env.bash" ]; then
    source "$BASH_CONFIG_DIR/env.bash"
fi

# Source standalone functions and aliases unconditionally (for non-interactive scripts/subshells)
# [ -f ~/.bash_functions ] && source ~/.bash_functions
[ -f ~/.bash_aliases ]   && source ~/.bash_aliases

# If not running interactively, stop here (skip interactive prompts, options, and tools)
case $- in
    *i*) ;;
      *) unset BASH_CONFIG_DIR; return ;;
esac

# Interactive-only modules
interactive_modules=(
    "options.bash"
    "prompt.bash"
	"functions.bash"
    "external.bash"
)

# Source interactive modules
for module in "${interactive_modules[@]}"; do
    file="$BASH_CONFIG_DIR/$module"

    if [ ! -r "$file" ]; then
        echo "[bashrc WARN] Skipping missing or unreadable module: $module ($file)" >&2
        continue
    fi

    source "$file"
done

unset BASH_CONFIG_DIR interactive_modules module file