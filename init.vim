call plug#begin()
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'jacoborus/tender.vim'
Plug 'kyoz/purify', { 'rtp': 'vim' }
Plug 'sainnhe/sonokai'
Plug 'drewtempelmeyer/palenight.vim'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'ayu-theme/ayu-vim'
Plug 'danilo-augusto/vim-afterglow'
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
" Abbrevations
:iabbrev @@    varshneybhupesh@gmail.com
:iabbrev webs  https://bhupesh-v.github.io

colorscheme palenight

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

set nu 
set ai
set autoindent smartindent
set ts=4
set expandtab
set completefunc=emoji#complete


let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#formatter = 'unique_tail'
let NERDTreeMinimalUI = 1  " Disable ? etc
let g:auto_save = 1  " enable AutoSave on Vim startup (vim-auto-save plugin)
let NERDTreeShowHidden=1  "Show hidden files (aka dotfiles)


" Autocommands
autocmd BufRead,BufNewFile * start "Switch to Insert mode when open a file

" vim-emoji doesn't replace :emoji_string: with the actual emoji by default
autocmd CompleteDone * call FixEmoji()
function! FixEmoji()
    %s/:\([^:]\+\):/\=emoji#for(submatch(1), submatch(0))/g
endfunction

"Close NERDTree if its the only open window
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

"For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
"Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
" < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
if (has("termguicolors"))
        set termguicolors
endif
