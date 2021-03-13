call plug#begin()
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'jacoborus/tender.vim'
Plug 'kyoz/purify', { 'rtp': 'vim' }
Plug 'sainnhe/sonokai'
Plug 'drewtempelmeyer/palenight.vim'
Plug 'ayu-theme/ayu-vim'
Plug 'danilo-augusto/vim-afterglow'
Plug 'junegunn/goyo.vim'
Plug 'psf/black', { 'branch': 'stable' }
Plug 'deoplete-plugins/deoplete-go', { 'do': 'make'}
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'voldikss/vim-floaterm'
Plug 'itchyny/lightline.vim'
Plug 'mhartington/oceanic-next'
Plug 'arzg/vim-colors-xcode'
" Plug 'vim-airline/vim-airline'
call plug#end()

" Key Mappings {{{

vnoremap <C-c> "+y
imap <C-v> <Esc>"+pi
nmap <F6> :NERDTreeToggle<CR>
noremap <F7> :e $MYVIMRC<CR>
noremap <F5> :source $MYVIMRC<CR>

" Write & quit on all tabs, windows
noremap <F9> :wqa<CR>
" Disable spell & start :terminal
nnoremap <F3> :set nospell <bar> :term<CR>
" Insert Date (dd mm, yyyy)
inoremap <F4> <C-R>=strftime("%d %b, %Y")<CR>
nnoremap <F4> "=strftime('%d %b, %Y')<CR>P
" Toggle code-folds
noremap <space> za
nnoremap <A-CR> :Goyo<CR>
" Tab to cycle through open splits
nnoremap <Tab> <C-w><C-w>
" Use Enter to switch to command mode
" nnoremap <CR> :
" Cycle through open buffers
nnoremap <S-Tab> :bn<CR>
" Use j/k to select from completion menu
" inoremap <expr> j pumvisible() ? "\<C-N>" : "j"
" inoremap <expr> k pumvisible() ? "\<C-P>" : "k"
inoremap <silent><expr> <TAB>
            \ pumvisible() ? "\<C-n>" :
            \ <SID>check_back_space() ? "\<TAB>" :
            \ deoplete#manual_complete()
function! s:check_back_space() abort "{{{
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction
"}}}

" Efficiently browse vim manuals using helpg
nnoremap <kPlus> :cn<CR>
nnoremap <kMinus> :cp<CR>
" Map A-m to :make
inoremap <A-m> <Esc>:make! <bar> botright cw<CR>
nnoremap <silent> <A-m> :make! <bar> botright cw<CR>
" Search selected text when in visual mode by pressing /
vmap / y/<C-R>"<CR>
nnoremap <S-t> :FloatermToggle<CR>
nnoremap <leader>b :!bkp %<CR>
" Opening Splits
nnoremap <leader>v :vsp<CR>
nnoremap <leader>h :sp<CR>
" Map keys in terminal mode
" listen up, CapsLock is already mapped to Esc via xmodmap
" So there is no need of this, but sometimes xmod starts behaving weirdly
if has('nvim')
    tnoremap <Esc> <C-\><C-n>
endif

" Move lines up/down using Shift + ↑ ↓ {{{
nnoremap <S-k> :m-2<CR>==
nnoremap <S-j> :m+<CR>==
inoremap <A-k> <Esc>:m-2<CR>==gi
inoremap <A-j> <Esc>:m+<CR>==gi
" Move a block/range of lines 
vnoremap <S-J> :m '>+1<CR>gv=gv
vnoremap <S-k> :m '<-2<CR>gv=gv 
" }}}

" Resizing Windows {{{
nnoremap <A-h> :vertical resize +3<CR>
nnoremap <A-l> :vertical resize -3<CR>
nnoremap <A-k> :resize +3<CR>
nnoremap <A-j> :resize -3<CR>
"}}}

" Custom Function calls {{{
nnoremap <S-r> :call AddCmdOuput()<CR>
noremap <F8> :call Toggle_transparent()<CR>
nnoremap <S-l> :call OpenLink()<CR>
nnoremap t :call ToggleComment()<CR>
nnoremap <F10> :call PrettyMe()<CR>
inoremap <F10> :call PrettyMe()<CR>
" Use vim-floaterm to show search results
xnoremap <leader>f <esc>:call SendQueryToFloatTerm()<CR>   
xnoremap <leader>t <esc>:split <bar> call SendQueryToTerm()<CR>
xnoremap <leader>s :<c-u>call SearchInternet()<CR>
" Open vim terminal with surf command
nnoremap <leader>c <esc>
"}}}

" Disable Arrow keys for good {{{
map <Left> <Nop>
map <Right> <Nop>
map <Up> <Nop>
map <Down> <Nop>
"}}}

"}}}

" Abbreviations
iabbr @@    varshneybhupesh@gmail.com
iabbr webs  https://bhupesh-v.github.io

" Auto pair brackets and stuff
" Lmao bye bye plugins
iabbr <silent> ( ()<Left><C-R>=Eatchar('\s')<CR>
iabbr <silent> { {}<Left><C-R>=Eatchar('\s')<CR>
iabbr <silent> [ []<Left><C-R>=Eatchar('\s')<CR>
iabbr <silent> " ""<Left><C-R>=Eatchar('\s')<CR>
iabbr <silent> ' ''<Left><C-R>=Eatchar('\s')<CR>
iabbr <silent> ` ``<Left><C-R>=Eatchar('\s')<CR>

func Eatchar(pat)
    " Remove extra space after expanded abbr
    let c = nr2char(getchar(0))
    return (c =~ a:pat) ? '' : c
endfunc

colorscheme ayu

" Common Settings {{{
set number 
" set rnu
set autoindent smartindent
set expandtab
set showcmd
" set completefunc=UltiSnips#ListSnippets()
set title
set autoread
set cursorline
set iskeyword+=-
set dictionary+=/usr/share/dict/words
set wildignorecase
set wildignore+=*/.git/*,*/site-packages/*,*/lib/*,*/bin/*,*.pyc
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg,*.avi,*.mp4,*.mkv,*.pdf,*.odt
set path+=**
set foldcolumn=2
" set noswapfile
set lazyredraw
" set thesaurus+=/home/bhupesh/mthesaur.txt
" set shada="NONE"
set completeopt-=preview
set noshowmode

let g:loaded_python_provider=0
let g:loaded_ruby_provider = 0
let g:loaded_node_provider = 0

let g:loaded_zipPlugin=1
let g:loaded_zip=1

let g:loaded_tarPlugin=1
let g:loaded_tar=1

let g:deoplete#enable_at_startup=1
"}}}

call deoplete#custom#option('auto_complete_delay', 100)

" lightline config {{{1
let g:lightline = {
            \ 'colorscheme': 'ayu_dark',
            \ 'separator': { 'left': '', 'right': '' },
            \ 'subseparator': { 'left': '', 'right': '' },
            \ }
" }}}

" Custom Global Highlights {{{
"
" Make current line bold
" highlight CursorLine cterm=bold gui=bold ctermbg=none guibg=none
" highlight CursorLineNr ctermbg=none guibg=none
" Bold the markers on fold column
hi FoldColumn cterm=bold gui=bold
" Highlight trailing white space
" highlight SpaceEnd ctermbg=red guibg=red
" autocmd BufWinEnter * match SpaceEnd /\s\+$/
hi MatchParen ctermbg=246 guibg=#7f8490
" }}}

" Netrw Settings {{{
"
" Use v to open file in right split
" Use t to open a file in a new tab
let g:netrw_banner=0         " disable annoying banner
let g:netrw_liststyle=3      " tree view
let g:netrw_browse_split = 2 " Open file in new vertical split
let g:netrw_preview=1
let g:netrw_altv = 1
let g:netrw_winsize = 27     " Fix width to 27%
let g:netrw_special_syntax=1 " Enable special file highlighting
let g:netrw_browsex_viewer= "xdg-open"
"}}}

" Airline Settings {{{
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#formatter = 'unique_tail'
"}}}

" NERDTree config {{{
let NERDTreeMinimalUI = 1  " Disable ? etc
let NERDTreeShowHidden=1  "Show hidden files (aka dotfiles)
let NERDTreeMapActivateNode='<space>'
let NERDTreeIgnore=['\.git$']
let g:NERDTreeWinSize=20
"}}}

" floaterm config {{{

let g:floaterm_title = "😎️"
let g:floaterm_autoinsert = v:false


hi FloatermBorder cterm=bold gui=bold guibg=NONE guifg=orange
" }}}

" Ulti-snips config {{{
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsListSnippets="<c-l>"
" let g:UltiSnipsJumpForwardTrigger="<c-j>"
" let g:UltiSnipsJumpBackwardTrigger="<c-k>"
let g:UltiSnipsSnippetDirectories=["UltiSnips", "vim-snippets", $HOME.'/Documents/.Varshney/snippets/']
" }}}

let g:auto_save = 1  " enable AutoSave on Vim startup (vim-auto-save plugin)
" Load my aliases
" Make sure a .vim_env_bash file exists
" Sample: https://github.com/Bhupesh-V/.Varshney/blob/master/.vim_bash_env
let $BASH_ENV = "~/.vim_bash_env"
" Toggle transparent mode
let g:is_transparent = 0

" Auto Commands {{{

" Set foldmethod based on file type
augroup FoldMethodType
    autocmd!
    autocmd FileType python,css,javascript,go,html,sh setlocal foldmethod=indent
    autocmd FileType vim setlocal foldmethod=marker
augroup END

" Set Indent level based on FileType
augroup FileIndentLevel
    autocmd!
    autocmd FileType htmldjango,cpp,yaml,html,css setlocal shiftwidth=2 tabstop=2 softtabstop=2
    autocmd FileType go,python,vim,sh setlocal tabstop=4 sts=4 shiftwidth=4
augroup END

" Map Caps Lock to Esc (must be X.Org compliant)
" au VimEnter * silent! !xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'
" au VimLeave * silent! !xmodmap -e 'clear Lock' -e 'keycode 0x42 = Caps_Lock'

" Set window title on every buffer switch
" autocmd bufenter * let &titlestring = "bhupesh on " . buffer_name("%")
" Close NERDTree if its the only open window
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

au FileType markdown setlocal spell

augroup SetMakePrg
    autocmd!
    au FileType go setlocal makeprg=go\ run\ %
    au FileType python setlocal makeprg=python3\ %
    au FileType sh setlocal makeprg=shellcheck\ %
augroup END

" Automatically adjust quickfix window height
" FROM: https://vim.fandom.com/wiki/Automatically_fitting_a_quickfix_window_height
au FileType qf call AdjustWindowHeight(3, 10)
function! AdjustWindowHeight(minheight, maxheight)
    exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
endfunction

"}}}

" My Plugins

" Toggle transparent mode (make sure this is always below colorscheme setting
function! Toggle_transparent()
    if g:is_transparent == 0
        hi Normal guibg=NONE ctermbg=NONE
        let g:is_transparent = 1
    else
        let g:is_transparent = 0
        set background=dark
    endif
endfunction

function! OpenURLUnderCursor()
  let s:uri = expand('<cWORD>')
  let s:uri = substitute(s:uri, '?', '\\?', '')
  let s:uri = shellescape(s:uri, 1)
  echo s:uri
endfunction
" nnoremap gx :call OpenURLUnderCursor()<CR>

" Run commands inside the editor & paste output in next line
function! AddCmdOuput()
    " A one liner for this can be nnoremap <S-r> !!sh<CR>
    try
        let cmd_output = systemlist(getline("."))
        echo "Executing " . getline(".")[0:3] . " ... "
    catch E684
        echo "Not a command"
        return
        if stridx(cmd_output[0], "command not found") == -1
            call append(line('.'), cmd_output)
        else
            redraw
            echo "⚠️  " . getline(".")[0:3] . ".. not found"
        endif
    endtry
endfunction

" Open hyper link in current line
function! OpenLink()
    let links = []
    try
        call substitute(getline('.'), 'http[s]\?:\/\/[^) \"]*', '\=add(links, submatch(0))', 'g')
        echo "Opening " . links[0]
        exe "silent! !xdg-open " . links[0]
    catch E684
        echo "No link found :("
        return
    endtry
endfunction

" Return 1 if file is a non-ascii file, otherwise 0
function! IsNonAsciiFile(file)
    let isNonAscii = 1
    let fileResult = system('file ' . a:file)
    " Check if file contains ascii or is empty
    if fileResult =~ "ASCII" || fileResult =~ "empty" || fileResult =~ "UTF"
        let isNonAscii = 0
    endif
    return isNonAscii
endfunction

" Indent Files based on file type
function! PrettyMe()
    if &filetype == "json"
        " See this: https://bhupesh-v.github.io/prettifying-json-files-using-bash-python-vim/ 
        exe "!pj %:p"
    elseif &filetype == "python"
        exe ":Black"
    elseif &filetype == "go"
        exe ":!gofmt -w -s %"
    else
        " Indent and Go back to my previous cursor pos
        exe "norm! gg=G\<C-o>"
    endif
endfunction

" Need to have a <space> before/after comment character
let g:comment_chars = {
            \ 'vim': { 'prefix': "\" ", 'suffix': "" },
            \ 'python': { 'prefix': "# ", 'suffix': "" },
            \ 'sh': { 'prefix': "# ", 'suffix': "" },
            \ 'go': { 'prefix': "// ", 'suffix': "" },
            \ 'html': { 'prefix': "<!-- ", 'suffix': " -->" },
            \ 'css': { 'prefix': "/* ", 'suffix': " */" },
            \ 'javascript': { 'prefix': "/* ", 'suffix': " */" },
            \ 'cpp': { 'prefix': "/* ", 'suffix': " */" },
            \ 'yaml': { 'prefix': "# ", 'suffix': "" },
            \ 'markdown': { 'prefix': "<!-- ", 'suffix': " -->" },
            \}

function! HandleInlineCode()
    let js_line_numbers = []
    let css_line_numbers = []
    let current_lino = line('.')
    exe "g/[</]style/call add(css_line_numbers, line('.'))"
    exe "g/[</]script/call add(js_line_numbers, line('.'))"
    if current_lino > min(js_line_numbers) && current_lino < max(js_line_numbers)
        let inlineCodeType = "javascript"
    elseif current_lino > min(css_line_numbers) && current_lino < max(css_line_numbers)
        let inlineCodeType = "css"
    else
        let inlineCodeType = "html"
    endif
    exe ":" . current_lino
    return inlineCodeType
endfunction

" Toggle Comment in Current Line
" Only for NeoVim & Vim >= 8
function! ToggleComment()
    " TODO: make it work in visual mode aka group selection
    " TODO: Detect whether a // is used or /*
    let current_line = trim(getline('.'))
    let comment = 0
    for lang_comment in keys(g:comment_chars)
        let lang_prefix = g:comment_chars[lang_comment]["prefix"]
        let lang_suffix = g:comment_chars[lang_comment]["suffix"]
        if current_line[0:len(lang_prefix)-1] == lang_prefix 
            call setline('.', current_line[len(lang_prefix):len(current_line)-len(lang_suffix)])
            let comment = 1
            :normal ==
            break
        endif
    endfor
    " fuck HTML
    if comment == 0 " add a comment
        if &filetype == "html"
            let code_type = HandleInlineCode()
            call setline('.', g:comment_chars[code_type]["prefix"] . trim(getline('.')) . g:comment_chars[code_type]["suffix"])
        else
            call setline('.', g:comment_chars[&filetype]["prefix"] . trim(getline('.')) . g:comment_chars[&filetype]["suffix"])
        endif
        :normal ==
    endif
endfunction

" Open Binary files in their appropriate viewer
autocmd bufenter *.pdf,*.png,*.gif,*.jpg,*.mpv,*.mkv,*.avi :call OpenNonTextFiles()
function! OpenNonTextFiles()
    let current_file = expand('%')
    if IsNonAsciiFile(current_file) == 1
        execute "silent! !xdg-open " . current_file
        " Switch to next buffer and delete this one
        if len(getbufinfo({'buflisted':1})) >= 2
            execute "bNext"
            execute "bd " . current_file
        else
            execute "enew"
        endif
    endif
endfunction

function! GetVisualSelection()
    " Thanks: https://stackoverflow.com/a/6271254/8209510
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
endfunction

function! SendQueryToFloatTerm()
    let selection = GetVisualSelection()
    exe "FloatermNew --height=0.6 --width=0.9 --wintype=float --disposable surf -dq \"" . selection . "\""
    " exe ":FloatermSend surf -dq \"" . selection . "\""
    " exe ":FloatermToggle"
endfunction

function! SendQueryToTerm()
    let selection = GetVisualSelection()
    exe ":term surf -dq \"" . selection . "\""
endfunction

let g:browser = "chromium-browser"
let g:search_engine = "duckduckgo"
" Open browser & search engine with currently selected text
function! SearchInternet()
    let selection = GetVisualSelection()
    let urlsafe = ""
    let search_engines = {
                \ 'google': "google.com/search?q=",
                \ 'duckduckgo': "duckduckgo.com/?q=",
                \ 'github': "github.com/search?q=",
                \ 'stackoverflow': "stackoverflow.com/search?tab=votes&q="
                \}
    let choices = {
                \'g':search_engines["google"],
                \'d':search_engines["duckduckgo"],
                \'s':search_engines["stackoverflow"],
                \'h':search_engines["github"]
                \}
    echo "Choose Search Engine:\n[g]oogle\n[d]uckduckgo\n[s]stackoverflow\ngit[h]ub\nChoice [g/d/s/h]: "
    let user_choice = nr2char(getchar())
    for char in split(selection, '.\zs')
        if matchend(char, '[-_.~a-zA-Z0-9]') >= 0
            let urlsafe = urlsafe . char
        else
            let decimal = char2nr(char)
            let urlsafe = urlsafe . "%" . printf("%02x", decimal)
        endif
    endfor
    echo "\nOpening Browser with [". choices[user_choice] . "] & query: ". selection
    exe "silent!" . system(g:browser . " " . choices[user_choice] . urlsafe) 
    normal! gv
endfunction

if (has("termguicolors"))
    set termguicolors
endif
