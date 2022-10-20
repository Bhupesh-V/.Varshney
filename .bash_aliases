# git aliases
alias gsh='git push'
alias gll='git pull'
alias gia='git-add'
alias gis='git status'
alias gic='git-commit'
alias gicl='git clone'


alias gib='git branch'
alias gibs='git-switch'
alias giws='source git-worktree-switch'
alias giw='source git-worktree-all'

alias gir='git restore'
alias gil='git log --graph --decorate --pretty=oneline --abbrev-commit'
alias gid='git diff'
# go aliases
alias gb="go build"
alias gr="go run"
alias gd="go doc -all"
alias gg="go get"
alias gt="go test ./... -v -coverpkg=./... -coverprofile=coverage.out"
alias gtc="go tool cover -html=coverage.out"
alias dc="docker-compose"
# python aliases
alias p='python3'
alias venv="python3 -m venv"
alias pdb="python3 -m pdb"
alias serve="python3 -m http.server"
# miscellaneous
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
alias bro="xfi | fzf --exact --prompt='Search File: ' --preview '(eye {} || tree -C {}) 2> /dev/null || cat {}' --pointer='🡆' --height 60% --reverse --color 'fg:#E6E1CF,fg+:#ddeeff,prompt:#A9DC76,pointer:#FF6188,header:#AB9DF2,query:#FFD866,hl+:#FFEE99' | xargs -I FILEP browse \"FILEP\""
alias til="locate -e '/home/bhupesh/Documents/til' | fzf | xargs glow --pager"
alias fbro="locate $HOME | fzf --exact --prompt='Search File: ' --pointer=🡆 --height 60% --reverse --color fg:#E6E1CF,fg+:#ddeeff,prompt:#A9DC76,pointer:#FF6188,header:#AB9DF2,query:#FFD866,hl+:#FFEE99 | xargs -I FILEP browse FILEP"
