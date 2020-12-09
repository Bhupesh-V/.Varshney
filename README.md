# .Varshney

My config &amp; .dotfiles managed by <a title="dotman is a simple, elegant & easy to use dotfiles manager" href="https://github.com/Bhupesh-V/dotman"><b>dotman 🖖</b></a>

<a href="https://github.com/Bhupesh-V/.Varshney/blob/master/LICENSE">
	<img alt="License: GPLv3" src="https://img.shields.io/github/license/Bhupesh-V/.Varshney" />
</a>
<a href="https://github.com/ellerbrock/open-source-badges">
	<img alt="bashit" src="https://badges.frapsoft.com/bash/v1/bash.png?v=103">
</a>
<a href="https://twitter.com/bhupeshimself">
	<img alt="Twitter: bhupeshimself" src="https://img.shields.io/twitter/follow/bhupeshimself.svg?style=social" target="_blank" />
</a>


## My setup 🖥

- **OS**: Ubuntu 18.04
- **DE**: Mate
- **SHELL**: bash
- **Editor**: NeoVim
- **TERM**: xterm-256color


## What's Inside 👀

> ~~I am pretty new to this stuff~~ (not anymore), so you won't find any scripts that hack NASA. Anyways hope you find something useful, Good luck 👍

- [`scripts`](#scripts)
- [`bash_functions`](#bash_functions)
- [`bash_aliases`](#bash_aliases)
- [`bashrc`](#bashrc)
- [`init.vim` or `.vimrc`](#initvim-or-vimrc)


### [`.bash_functions`](https://github.com/Bhupesh-V/.Varshney/blob/master/.bash_functions)

<table>
	<tr>
		<th>Function Name</th>
		<th width="70%">Description & Demo</th>
	</tr>
	<tr>
		<td rowspan="2" align="center"><code><b>netu</b></code>🌐</td>
		<td align="center">Analyze network data usage</td>
	</tr>
	<tr><td><details><summary>Demo</summary>
			<img title="netu: check network usage stats" alt="demo of netu gif" src="https://user-images.githubusercontent.com/34342551/90170484-c280cd80-ddbd-11ea-9d38-71821250989c.png">
		</details>
	</td>
	</tr>
	<tr>
		<td align="center"><code><b>search</b></code>🔍</td>
		<td align="center">Invoke browser directly with search results</td>
	</tr>
	<tr>
		<td align="center"><code><b>vcd</b></code>🐍</td>
		<td align="center">Automatically activate python virtual environments on cd</td>
	</tr>
	<tr>
		<td rowspan="2" align="center"><code><b>urlencode</b></code>🔗</td>
		<td align="center">Dependency of search(), converts strings to URL safe version.</td>
	</tr>
	<tr><td><details><summary>Demo</summary>
		<img title="urlencode: encode strings to URL safe version" alt="demo of urlencode" src="https://user-images.githubusercontent.com/34342551/90170221-54d4a180-ddbd-11ea-9c76-029a70f5dc37.png">
	</details>
	</td>
	</tr>
	<tr>
		<td rowspan="2" align="center"><code><b>scd</b></code>💡</td>
		<td align="center"><p>[s]mart cd searches absolute path names of directories inside your system and switches to them automatically. No need to remember any locations !!. 
		<a href="https://bhupesh-v.github.io/creating-a-smart-alternative-to-cd/">Read More</a></p>
		Also see <a href="https://github.com/Bhupesh-V/.Varshney/blob/master/scd-completions.bash"><samp>scd-completions.bash</samp></a> for automatic tab suggestions.
		</td>
	</tr>
	<tr><td><details><summary>Demo</summary>
		<img title="scd : switch directories from anywhere to anywhere" alt="scd demo gif" src="https://user-images.githubusercontent.com/34342551/90309212-1eee0500-df04-11ea-9695-490103823164.gif">
	</details>
	</td>
	</tr>
	<tr>
		<td align="center"><code><b>alarm</b></code>⏰</td>
		<td align="center">A single line utility for a timer/alarm</td>
	</tr>
	<tr>
		<td align="center"><code><b>myip</b></code>🌐</td>
		<td align="center">A single line utility for showing my IP address</td>
	</tr>
	<tr>
		<td align="center"><code><b>extract</b></code>📦</td>
		<td align="center">A utility for extracting different archives in an easy way</td>
	</tr>
</table>


### [`scripts`](https://github.com/Bhupesh-V/.Varshney/blob/master/scripts/)

<table>
	<tr>
		<th>Name</th>
		<th width="70%">Description & Demo</th>
	</tr>
	<tr>
		<td rowspan="2" align="center"><b><a href="https://github.com/Bhupesh-V/.Varshney/blob/master/scripts/sys.sh">sys.sh</a></b></td>
		<td align="center">A realtime update of your system using common shell commands</td>
	</tr>
	<tr><td align="center"><details><summary>Demo</summary>
		<img title="sys.sh: get realtime update of your linux system" alt="sys.sh demo gif" src="https://user-images.githubusercontent.com/34342551/96346219-5cb00b00-10b8-11eb-90fb-d21f6ffa7c12.gif">
	</details></td>
	</tr>
	<tr>
		<td rowspan="2" align="center"><b><a href="https://github.com/Bhupesh-V/.Varshney/blob/master/scripts/md.sh">md.sh</a></b></td>
		<td align="center">A utility to watch a Markdown file & build its HTML preview using commonmarker</td>
	</tr>
	<tr><td align="center"><details><summary>Demo</summary>
		<img title="md.sh: utility to watch a Markdown file & build its HTML preview using commonmarker" alt="md.sh demo gif" src="https://user-images.githubusercontent.com/34342551/97805510-a4b85b80-1c7c-11eb-9efe-3eedbb76a70b.gif">
	</details></td>
	</tr>
	<tr>
		<td rowspan="2" align="center"><b><a href="https://github.com/Bhupesh-V/.Varshney/blob/master/scripts/colors.sh">colors.sh</a></b></td>
		<td align="center">A utility to check color capability of your terminal</td>
	</tr>
	<tr><td align="center"><details><summary>Demo</summary>
		<img title="colors.sh: utility to check color capabilities of your terminal" alt="colors.sh demo png" src="https://user-images.githubusercontent.com/34342551/97805252-f2cc5f80-1c7a-11eb-92be-31ac80ec0719.png">
	</details></td>
	</tr>
	<tr>
		<td align="center"><b><a href="https://github.com/Bhupesh-V/.Varshney/blob/master/scripts/my-prs.py">my-prs.py</a></b></td>
		<td align="center">A utility to list a github user's pull requests in a nicely readable markdown file with 0 dependencies.</td>
	</tr>
</table>


### [`.bash_aliases`](https://github.com/Bhupesh-V/.Varshney/blob/master/.bash_aliases)

Some handy aliases under different categories.

1. Git
   ```bash
   alias scommit='git commit -m'
   alias commit='git commit'
   alias clone='git clone'
   alias log='git log --graph --decorate --pretty=oneline --abbrev-commit'
   alias gdiff='git diff'
   # undo last local commit
   alias undo='git reset HEAD~'
   ```

2. Go
   ```bash
   alias gb="go build"
   alias gr="go run"
   alias gd="go doc"
   alias gg="go get"
   alias gt="go test"
   ```

3. Miscellaneous
   ```bash
   # create python virtualenv
   alias venv="python3 -m venv"
   # watch realtime system info
   alias sys="watch -ct -n0 $HOME/Documents/.Varshney/scripts/sys.sh"
   # python http server
   alias serve="python3 -m http.server"
   # grep pattern inside files
   alias lk="grep -nir --exclude-dir=.git"
   # search history for commands
   alias hg="history | grep"
   ```


### [`.bashrc`](https://github.com/Bhupesh-V/.Varshney/blob/master/.bashrc)

My `PS1` is highly customized.

<img align="center" title="My PS1" alt="PS1 prompt demo" src="https://user-images.githubusercontent.com/34342551/90950968-29fce400-e474-11ea-8f11-c375383e4606.png">

Here is how its done

```bash
# Gib me all the colors 
export TERM=xterm-256color
# disable the default virtualenv prompt change
export VIRTUAL_ENV_DISABLE_PROMPT=1

# color definitions
RESET="\e[0m"
BOLD_BLACK_FG="\e[1;30m"
ORANGE_FG="\e[38;5;214m"
ORANGE_BG="\e[48;5;214m"
GRAY_BG="\e[48;5;234m"
GRAY_FG="\e[38;5;234m"
BOLD_L_YELLOW=$'\e[1;38;5;11m'
BOLD_RED_FG=$'\e[1;38;5;9m'
BOLD_GREEN_FG=$'\e[1;32m'

random_emoji() {
	# add a random emoticon (mostly face emojis)
	printf "%b" "\U1F$(shuf -i600-640 -n1)"
}

get_git_branch() {
    curr_branch=$(git branch 2> /dev/null | awk '/*/ {print $2}')
    [ "$curr_branch" ] && printf "%s" "($(tput bold)$(tput setaf 208)$curr_branch$(tput sgr0))"
}

pc_uptime() {
    uptime -p | awk '{for (i=2; i<NF; i++) printf $i " "; if (NF >= 1) print $NF; }'
}

virtualenv_ps1() {
    [ "$VIRTUAL_ENV" ] && printf "%s" " $(basename "$VIRTUAL_ENV")"
}

rightprompt() {
    # display stuff on right side of prompt
    printf '%*s' $COLUMNS "$(pc_uptime)"
}

# handles cursor position
RIGHT_PROMPT="\n\$(tput sc; rightprompt; tput rc)"

custom_prompt() {
	EXIT="$?"
	last_command_status=$([ "$EXIT" != 0 ] && printf "%s" "\[$BOLD_RED_FG\]✘")
    arrp="\[$GRAY_BG\] $last_command_status $(random_emoji) \[$GRAY_FG\]\[$ORANGE_BG\]\[$ORANGE_BG\]\[$BOLD_BLACK_FG\] $(virtualenv_ps1) \[$RESET\]\[$ORANGE_FG\]\[$RESET\]"
    PS1="\[$BOLD_L_YELLOW\]\[$RIGHT_PROMPT\]\[$RESET\]\[$BOLD_GREEN_FG\]\w\[$RESET\] $(get_git_branch)\n$arrp "
}

if [ "$color_prompt" = yes ]; then
    #PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    PROMPT_COMMAND=custom_prompt
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt
```


### [`init.vim` or `.vimrc`](https://github.com/Bhupesh-V/.Varshney/blob/master/init.vim)

![sexy-nvim-setup](https://user-images.githubusercontent.com/34342551/99086457-93ae0980-25ef-11eb-9a08-87d5630206b4.png)

Current colorscheme: `palenight`

> Learn more about vim in my **[my-vim-cheatsheet](https://github.com/Bhupesh-V/til/blob/master/Miscellaneous/my-vim-cheatsheet.md)**

- Plugins:
  1. [vim-devicons](https://github.com/ryanoasis/vim-devicons) - for file icons
  2. [NERDTree](https://github.com/scrooloose/nerdtree) - for tree like menu
  3. [vim-auto-save](https://github.com/907th/vim-auto-save) - for auto-saving files (no need to `:w`)
  4. [vim-airline](https://github.com/vim-airline/vim-airline) - for status bar at bottom
  5. [black.vim](https://github.com/psf/black/blob/master/plugin/black.vim) - python formatter
  6. [vim-shfmt](https://github.com/z0mbix/vim-shfmt) - to format shell scripts

- Some of my fav colorschemes:
  - [ayu](https://github.com/ayu-theme/ayu-vim)
  - [sonokai](https://github.com/sainnhe/sonokai)
  - [darcula](https://github.com/doums/darcula)
  - [purify](https://github.com/kyoz/purify)
  - [tender.vim](https://github.com/jacoborus/tender.vim)
  - [palenight](https://github.com/drewtempelmeyer/palenight.vim)

## Author [![bhupesh-twitter-image](https://kutt.it/bhupeshimself)](https://twitter.com/bhupeshimself)
**🤓 [Bhupesh Varshney](https://bhupesh-v.github.io)** 

<img height="200px" src="https://user-images.githubusercontent.com/34342551/101245824-8e973280-3735-11eb-982e-17d59d74891a.png">

## ☺️ Show your support

Support me by giving a ⭐️ if this project helped you! or just [![Twitter URL](https://img.shields.io/twitter/url?style=social&url=https%3A%2F%2Fgithub.com%2FBhupesh-V%2F.Varshney%2F)](https://twitter.com/intent/tweet?url=https://github.com/Bhupesh-V/.Varshney&text=.Varshney%20via%20@bhupeshimself)

<a href="https://liberapay.com/bhupesh/donate">
  <img title="librepay/bhupesh" alt="Donate using Liberapay" src="https://liberapay.com/assets/widgets/donate.svg" width="100">
</a>
<a href="https://ko-fi.com/bhupesh">
  <img title="ko-fi/bhupesh" alt="Support on ko-fi" src="https://user-images.githubusercontent.com/34342551/88784787-12507980-d1ae-11ea-82fe-f55753340168.png" width="185">
</a>


## 📝 License

Copyright © 2020 [Bhupesh Varshney](https://github.com/Bhupesh-V).<br />
This project is [GPLv3](https://github.com/Bhupesh-V/.Varshney/blob/master/LICENSE) licensed.

![GPLv3-logo](https://www.gnu.org/graphics/gplv3-with-text-136x68.png)
