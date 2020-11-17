call plug#begin()
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'vim-airline/vim-airline'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'jacoborus/tender.vim'
Plug 'kyoz/purify', { 'rtp': 'vim' }
Plug 'sainnhe/sonokai'
Plug 'drewtempelmeyer/palenight.vim'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'ayu-theme/ayu-vim'
Plug 'danilo-augusto/vim-afterglow'
Plug 'junegunn/goyo.vim'
Plug 'psf/black', { 'branch': 'stable' }
Plug 'z0mbix/vim-shfmt', { 'for': 'sh' }
Plug 'junegunn/vim-emoji'
Plug 'ryanoasis/vim-devicons'
call plug#end()

" Key Mappings
" Use Shit+Ctrl+v to paste from anywhere
" Enable Visual Mode select text, press Ctrl+c to copy
" Don't Use Ctrl+v to paste (its kinda messed up rn)
vnoremap <C-c> "+y
imap <C-v> <esc> "+pi
nmap <F6> :NERDTreeToggle<CR>
map <F7> :e $MYVIMRC<CR>
map <F8> :call Toggle_transparent()<CR>
map <F5> :source $MYVIMRC<CR>
" Write & quit on all tabs, windows
map <F9> :wqa<CR>
" Move lines up/down using Shift + ↑ ↓ 
nnoremap <S-Up> :m-2<CR>
inoremap <S-Up> <Esc>:m-2<CR>
inoremap <S-Down> <Esc>:m+<CR>
nnoremap <S-Down> :m+<CR>

nnoremap <S-r> :call AddCmdOuput()<CR>
" Abbrevations
:iabbrev @@    varshneybhupesh@gmail.com
:iabbrev webs  https://bhupesh-v.github.io

colorscheme dracula

" Toggle transparent mode (make sure this is always below colorscheme setting
let g:is_transparent = 0
function! Toggle_transparent()
		if g:is_transparent == 0
				hi Normal guibg=NONE ctermbg=NONE
				let g:is_transparent = 1
		else
				let g:is_transparent = 0
				set background=dark
		endif
endfunction

set number 
set autoindent smartindent
set ts=4
set expandtab
set showcmd
set completefunc=emoji#complete
" Make sure the spawned shell is an interactive shell (expands my aliases)
" set shellcmdflag=-ic
" netrw configs
" Use v to open file in right window
" Use t to open a file in a new tab
let g:netrw_banner=0         " disable annoying banner
let g:netrw_liststyle=3      " tree view
let g:netrw_browse_split = 2 " Open file in new vertical split
let g:netrw_altv = 1
let g:netrw_winsize = 25     " Fix width to 25%

" airline configs
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:auto_save = 1  " enable AutoSave on Vim startup (vim-auto-save plugin)

" NERDTRee config
let NERDTreeMinimalUI = 1  " Disable ? etc
let NERDTreeShowHidden=1  "Show hidden files (aka dotfiles)

" Ulti snips config
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" Autocommands
autocmd BufRead,BufNewFile * start "Switch to Insert mode when open a file

" vim-emoji doesn't replace :emoji_string: with the actual emoji by default
autocmd CompleteDone * :call FixEmoji()
function! FixEmoji()
		let current_word = expand('<cWORD>')
		let current_word = current_word[1:strlen(current_word)-2]
		let acemoji = emoji#for(current_word)
        echo acemoji
		" exe '%s/' . expand('<cWORD>') . '/' . acemoji
		" :%s/:\([^:]\+\):/\=emoji#for(submatch(1), submatch(0))/ge
		" :normal <C-o>
endfunction

"Close NERDTree if its the only open window
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Run commands inside the editor & paste output in next line
function! AddCmdOuput()
        echo "Executing " . getline(".")[0:3] . " ... "
		let cmd_output = systemlist(getline("."))
		if stridx(cmd_output[0], "command not found") == -1
				call append(line('.'), cmd_output)
        else
                redraw
                echo "⚠️  " . getline(".")[0:3] . ".. not found"
		endif
endfunction
"For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
"Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
" < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
if (has("termguicolors"))
		set termguicolors
endif
