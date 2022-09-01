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

- **OS**: Ubuntu 20.04
- **DE**: Mate
- **SHELL**: bash
- **Editor**: NeoVim
- **TERM**: xterm-256color


## What's Inside 👀

> ~~I am pretty new to this stuff~~ (not anymore), so you won't find any scripts that hack NASA. Anyways, hope you find something useful, Good luck 👍

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
		<td>Analyze network data usage</td>
	</tr>
	<tr><td><details><summary>Demo</summary>
			<img title="netu: check network usage stats" alt="demo of netu gif" src="https://user-images.githubusercontent.com/34342551/90170484-c280cd80-ddbd-11ea-9d38-71821250989c.png">
		</details>
	</td>
	</tr>
	<tr>
		<td align="center"><code><b>vcd</b></code>🐍</td>
		<td>Automatically activate python virtual environments on cd</td>
	</tr>
	<tr>
		<td rowspan="2" align="center"><code><b>scd</b></code>💡</td>
		<td><p>[s]mart cd searches absolute path names of directories inside your system and switches to them automatically. No need to remember any locations !!. 
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
		<td>A single line utility for a timer/alarm</td>
	</tr>
	<tr>
		<td align="center"><code><b>myip</b></code>🌐</td>
		<td>A single line utility for showing my IP address</td>
	</tr>
	<tr>
		<td align="center"><code><b>extract</b></code>📦</td>
		<td>A utility for extracting different archives in an easy way</td>
	</tr>
</table>


### [`scripts`](https://github.com/Bhupesh-V/.Varshney/blob/master/scripts/)


1. [**sys**](https://github.com/Bhupesh-V/.Varshney/blob/master/scripts/sys)
   > A realtime update of your system using common shell commands
   <details><summary>Demo</summary>
   <img title="sys: get realtime update of your linux system" alt="sys.sh demo gif" src="https://user-images.githubusercontent.com/34342551/96346219-5cb00b00-10b8-11eb-90fb-d21f6ffa7c12.gif">
   </details>

   Install
   ```
   wget -q https://raw.githubusercontent.com/Bhupesh-V/.Varshney/master/scripts/sys && chmod +x sys && mv sys $HOME/.local/bin/
   ```

2. [**md**](https://github.com/Bhupesh-V/.Varshney/blob/master/scripts/md)
   > A utility to watch a Markdown file & build its HTML preview using commonmarker
   <details><summary>Demo</summary>
   <img title="md: utility to watch a Markdown file & build its HTML preview using commonmarker" alt="md.sh demo gif" src="https://user-images.githubusercontent.com/34342551/97805510-a4b85b80-1c7c-11eb-9efe-3eedbb76a70b.gif">
   </details>

   Install
   ```
   wget -q https://raw.githubusercontent.com/Bhupesh-V/.Varshney/master/scripts/md && chmod +x md && mv md $HOME/.local/bin/
   ```

3. [**colors**](https://github.com/Bhupesh-V/.Varshney/blob/master/scripts/colors)
   > A utility to check color capability of your terminal
   <details><summary>Demo</summary>
   <img title="colors: utility to check color capabilities of your terminal" alt="colors.sh demo png" src="https://user-images.githubusercontent.com/34342551/97805252-f2cc5f80-1c7a-11eb-92be-31ac80ec0719.png">
   </details>

   Install
   ```
   wget -q https://raw.githubusercontent.com/Bhupesh-V/.Varshney/master/scripts/colors && chmod +x colors && mv colors $HOME/.local/bin/
   ```

4. [**myprs**](https://github.com/Bhupesh-V/.Varshney/blob/master/scripts/myprs)
   > A python utility to list a github user's pull requests in a nicely readable markdown file with 0 external dependencies.

   Install
   ```
   wget -q https://raw.githubusercontent.com/Bhupesh-V/.Varshney/master/scripts/myprs && chmod +x myprs && mv myprs $HOME/.local/bin/
   ```
5. [**bkp**](https://github.com/Bhupesh-V/.Varshney/blob/master/scripts/bkp)
   > A python utility to backup files on Github as a Secret Gist (0 dependency)

   Install
   ```
   wget -q https://raw.githubusercontent.com/Bhupesh-V/.Varshney/master/scripts/bkp && chmod +x bkp && mv bkp $HOME/.local/bin/
   ```
6. [**contributors**](https://github.com/Bhupesh-V/.Varshney/blob/master/scripts/contributors)
   > A python utility to list all the contributors on your github repositories 

   Install
   ```
   wget -q https://raw.githubusercontent.com/Bhupesh-V/.Varshney/master/scripts/contributors && chmod +x contributors && mv contributors $HOME/.local/bin/
   ```
7. [**gif**](https://github.com/Bhupesh-V/.Varshney/blob/master/scripts/gif)
   > A shell utility to convert videos to high-quality GIFs using ffmpeg

   Install
   ```
   wget -q https://raw.githubusercontent.com/Bhupesh-V/.Varshney/master/scripts/gif && chmod +x gif && mv gif $HOME/.local/bin/
   ```
8. [**surf**](https://github.com/Bhupesh-V/.Varshney/blob/master/scripts/surf)
   > A python script to surf the web from command line, powered by searx (0 external dependencies)
   <details><summary>Demo</summary>
   <img title="surf.py surf internet in terminal" alt="surf.py demo png" src="https://user-images.githubusercontent.com/34342551/108616880-9e223f80-7437-11eb-988d-8b048fb39af2.gif">
   </details>

   Install
   ```
   wget -q https://raw.githubusercontent.com/Bhupesh-V/.Varshney/master/scripts/surf && chmod +x surf && mv surf $HOME/.local/bin/
   ```
9. [**oib (open in browser)**](https://github.com/Bhupesh-V/.Varshney/blob/master/scripts/oib)
   > A utility to open a text-file as a HTML page so that I can use grammarly web extension `-_-`

   Install
   ```
   wget -q https://raw.githubusercontent.com/Bhupesh-V/.Varshney/master/scripts/oib && chmod +x oib && mv oib $HOME/.local/bin/
   ```

#### Keyboard Shortcuts

|    Shortcut    |    Purpose    |
|:-------------:|:-------------|
|  `F3` |    Open **:term**   |
|  `F4` |    Insert Current Date (dd mm, yyyy)   |
|  `F5` |    Source **$MYVIMRC**   |
|  `F6` |    **:NERDToggle**   |
|  `F7` |    Edit **$MYVIMRC**   |
|  `F8` |    Switch to Transparent Mode   |
|  `F9` |    Write and Quit on all buffers (Kill Switch)   |
|  `F10` |    Indent based on FileType   |
|  `Alt` + `m` |  Build & Run code using **:make**  |
|  `Alt` + `h` |  Vertical resize +3  |
|  `Alt` + `l` |  Vertical resize -3  |
|  `Alt` + `k` |  Horizontal resize +3  |
|  `Alt` + `j` |  Horizontal resize +3  |
|  `Alt` + `<CR>` |  Switch to **:Goyo** Mode  |
|  `Shift` + `k` |  Move line(s) up  |
|  `Shift` + `j` |  Move line(s) down  |
|  `Shift` + `r` |  Run linux Command at current line  |
|  `Shift` + `l` |  Open hyperlink at current line  |
|  `Shift` + `t` |  Switch buffer in current window |
|  `Ctrl` + `c` |   Copy in Visual Mode  |
|  `Ctrl` + `v` |   Paste in Insert Mode |
|  `t` |    Toggle Comment in Current line (Normal Mode)  |
|  `<space>` |    Toggle Fold at Current line |
|  `<Tab>` |  Switch Windows |


## Author [![bhupesh-twitter-image](https://kutt.it/bhupeshimself)](https://twitter.com/bhupeshimself)
**🤓 [Bhupesh Varshney](https://bhupesh.me)** 

<img height="200px" src="https://user-images.githubusercontent.com/34342551/101245824-8e973280-3735-11eb-982e-17d59d74891a.png">

## ☺️ Show your support

Support me by giving a ⭐️ if this project helped you! or just [![Twitter URL](https://img.shields.io/twitter/url?style=social&url=https%3A%2F%2Fgithub.com%2FBhupesh-V%2F.Varshney%2F)](https://twitter.com/intent/tweet?url=https://github.com/Bhupesh-V/.Varshney&text=.Varshney%20via%20@bhupeshimself)

## 📝 License

Copyright © 2020 [Bhupesh Varshney](https://github.com/Bhupesh-V).<br />
This project is [GPLv3](https://github.com/Bhupesh-V/.Varshney/blob/master/LICENSE) licensed.

![GPLv3-logo](https://www.gnu.org/graphics/gplv3-with-text-136x68.png)
