alias gsh='git push'
alias gll='git pull'
alias gia='git-add'
alias gib='git branch'
alias gich='git-switch'
alias gis='git status'
alias gir='git restore'
alias gisc='git-commit'
alias gic='git commit'
alias gicl='git clone'
alias gil='git log --graph --decorate --pretty=oneline --abbrev-commit'
alias gim='git merge'
alias gid='git diff'
# undo last commit (don't unstage everything)
alias gius='git reset --soft HEAD^'
alias gb="go build"
alias gr="go run"
alias gd="go doc -all"
alias gg="go get"
alias gt="go test ./... -v -coverpkg=./... -coverprofile=coverage.out"
alias gtc="go tool cover -html=coverage.out"
alias dc="docker-compose"
alias p='python3'
alias venv="python3 -m venv"
alias pdb="python3 -m pdb"
alias serve="python3 -m http.server"
alias n="nvim.appimage"
alias dotman='$HOME/dotman/dotman.sh'
alias update='sudo apt-get update'
alias upgrade='sudo apt-get upgrade'
alias cd="vcd"
alias sys="watch -ct -n0 sys"
alias bb="jekyll serve --watch"
alias lt="ls --human-readable --size -1 -S --classify"
alias browse="xdg-open > /dev/null 2>&1"
# open a random file from current dir
alias amaze="find . -type f -print0 | shuf -z -n 1 | xargs -0 browse > /dev/null 2>&1"
alias bro="xfi | fzf --prompt='Search File: ' --preview '(eye {} || tree -C {}) 2> /dev/null || cat {}' --pointer='🡆' --height 60% --reverse --color 'fg:#E6E1CF,fg+:#ddeeff,prompt:#A9DC76,pointer:#FF6188,header:#AB9DF2,query:#FFD866,hl+:#FFEE99' | xargs -I FILEP browse \"FILEP\""

