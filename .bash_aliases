alias gsh='git push'
alias gll='git pull'
alias gia='git add -A'
alias gib='git branch'
alias gich='git checkout'
alias gis='git status'
alias gir='git restore'
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
alias gt="go test ./... -v -coverpkg=./... -coverprofile=coverage.out"
alias gtc="go tool cover -html=coverage.out"
alias n="nvim"
alias p='python3'
alias b=bash
alias venv="python3 -m venv"
alias dotman='$HOME/dotman/dotman.sh'
alias update='sudo apt-get update'
alias upgrade='sudo apt-get upgrade'
alias cd="vcd"
alias serve="python3 -m http.server"
# alias lk="grep -nir --exclude-dir={_site,.git,.github} | awk -f ~/Documents/.Varshney/scripts/pretty-grep.awk"
alias sys="watch -ct -n0 sys"
alias bb="jekyll serve --watch"
alias lc="\$HOME/Documents/.Varshney/scripts/last-modify.sh"
alias lt="ls --human-readable --size -1 -S --classify"
alias browse="xdg-open 2>/dev/null"
# Quickly add things to a todo-list. Usage: remember milk
alias todo="xargs -I TODO  echo \"[ ] TODO\" >> ~/todo <<<"
