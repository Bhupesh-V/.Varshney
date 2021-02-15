alias gsh='git push'
alias gll='git pull'
alias gia='git add -A'
alias gib='git branch'
alias gich='git checkout'
alias gis='git status'
alias gisc='git commit -m'
# Add your staged changes to the previous commit
# while preserving your commit message
alias giac='git commit --amend -C HEAD'
alias gic='git commit'
alias gicl='git clone'
alias gil='git log --graph --decorate --pretty=oneline --abbrev-commit'
alias gim='git merge'
alias gid='git diff'
# undo last commit (unstage everything)
alias giu='git reset HEAD~'
# undo last commit (don't unstage everything)
alias gius='git reset --soft HEAD^'
alias gb="go build"
alias gr="go run"
alias gd="go doc -all"
alias gg="go get"
alias gt="go test"
alias n="nvim"
alias p='python3'
alias b=bash
alias venv="python3 -m venv"
alias dotman='$HOME/dotman/dotman.sh'
alias update='sudo apt-get update'
alias upgrade='sudo apt-get upgrade'
alias cd="vcd"
alias serve="python3 -m http.server"
alias lk="grep -nir --exclude-dir={.git,.github}"
alias sys="watch -ct -n0 \$HOME/Documents/.Varshney/scripts/sys.sh"
alias bb="jekyll serve --watch"
alias md="\$HOME/Documents/.Varshney/scripts/md.sh"
alias bkp="\$HOME/Documents/.Varshney/scripts/backup_as_gist.py"
alias gif="\$HOME/Documents/.Varshney/scripts/convert-to-gif.sh"
alias lc="\$HOME/Documents/.Varshney/scripts/last-modify.sh"
alias lt="ls --human-readable --size -1 -S --classify"
alias browse="xdg-open 2>/dev/null"
