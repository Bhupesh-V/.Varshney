call plug#begin()
Plug 'roxma/nvim-completion-manager'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'gilgigilgil/anderson.vim'
Plug 'jacoborus/tender.vim'
Plug 'kyoz/purify', { 'rtp': 'vim' }
Plug 'arcticicestudio/nord-vim'
Plug 'jaredgorski/spacecamp'
call plug#end()

vnoremap <C-c> "+y
map <C-v> "+p
nmap <F6> :NERDTreeToggle<CR>

colorscheme purify

set nu
set ai
set autoindent
set ts=4
set expandtab
set mouse=v

let g:airline_powerline_fonts = 1
