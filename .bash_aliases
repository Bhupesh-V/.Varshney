alias gsh='git push'
alias gll='git pull'
alias gia='git add -A'
alias gib='git branch'
alias gich='git checkout'
alias gis='git status'
alias gir='git restore'
alias gisc='git-commit'
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
alias p='python3'
alias venv="python3 -m venv"
alias pdb="python3 -m pdb"
alias serve="python3 -m http.server"
alias n="nvim"
alias b=bash
alias dotman='$HOME/dotman/dotman.sh'
alias update='sudo apt-get update'
alias upgrade='sudo apt-get upgrade'
alias cd="vcd"
alias sys="watch -ct -n0 sys"
alias bb="jekyll serve --watch"
alias lc="\$HOME/Documents/.Varshney/scripts/last-modify.sh"
alias lt="ls --human-readable --size -1 -S --classify"
alias browse="xdg-open > /dev/null 2>&1"
# open a random file from current dir
alias amaze="find . -type f -print0 | shuf -z -n 1 | xargs -0 browse > /dev/null 2>&1"
# Quickly add things to a todo-list. Usage: remember milk
alias todo="xargs -I TODO  echo \" - [ ] TODO\" >> ~/todo.md <<<"
alias bro="locate -ei "$HOME" | fzf --prompt='Open File: ' --preview '(eye {} || tree -C {}) 2> /dev/null | head -200' --pointer='🡆' --header='Choose file to open' --height 40% --reverse --color 'fg:#E6E1CF,fg+:#ddeeff,bg:#2B292E,bg+:#3D3B40,prompt:#A9DC76,pointer:#FF6188,header:#AB9DF2,query:#FFD866,hl+:#FFEE99' | xargs browse"

