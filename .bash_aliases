alias push='git push'
alias pull='git pull'
alias add='git add -A'
alias branch='git branch'
alias switch='git checkout'
alias status='git status'
alias scommit='git commit -m'
alias commit='git commit'
alias clone='git clone'
alias log='git log --graph --decorate --pretty=oneline --abbrev-commit'
alias merge='git merge'
alias gdiff='git diff'
alias p='python3'
alias dotman='$HOME/dotman/dotman.sh'
alias update='sudo apt-get update'
alias upgrade='sudo apt-get upgrade'
alias z=zsh
alias b=bash
alias cd="vcd"
alias venv="python3 -m venv"
alias sys="watch -ct -n0 $HOME/Documents/.Varshney/scripts/sys.sh"
alias serve="python3 -m http.server"
alias gb="go build"
alias gr="go run"
alias gd="go doc"
alias gg="go get"
alias gt="go test"
alias lk="grep -nir --exclude-dir=.git"
alias hg="history | grep"
alias bb="jekyll serve --watch"
wib() {
	# determine total words in my blog
	blog_dir="$HOME"/Desktop/Bhupesh-V.github.io/
	printf "Total Blogs: %s" "$(ls "$blog_dir"/_posts/ | wc -l)"
	printf "\n%s" "Total Words: "
	grep -nir -o -P '.{0,5} totalwords' --exclude-dir=tag --exclude "feed.xml" "$blog_dir/"_site | awk '{print $2}' | awk '{s+=$0} END {print s}'
}
gdl() {
	# Get actual drive public link
	str="$1"
	# remove everything after the last /
	remove_last=${str%/*}
	# get everything after the last /
	get_last=${remove_last##*/}
	echo "https://drive.google.com/uc?export=view&id=$get_last"
}