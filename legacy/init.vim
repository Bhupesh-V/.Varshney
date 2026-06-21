call plug#begin()
" Must have plugins
Plug '907th/vim-auto-save'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'tpope/vim-surround'
Plug 'preservim/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'itchyny/lightline.vim'
Plug 'voldikss/vim-floaterm'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'nacro90/numb.nvim'
Plug 'junegunn/goyo.vim'
" Colorschemes
Plug 'sainnhe/sonokai'
Plug 'drewtempelmeyer/palenight.vim'
Plug 'franbach/miramare'
Plug 'arzg/vim-colors-xcode'
Plug 'NLKNguyen/papercolor-theme'
Plug 'ayu-theme/ayu-vim'
Plug 'lifepillar/vim-gruvbox8'
Plug 'crusoexia/vim-monokai'
Plug 'https://git.sr.ht/~novakane/kosmikoa.nvim'
" Miscellaneous
Plug 'psf/black', { 'branch': 'stable' }
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-compe'
Plug 'dart-lang/dart-vim-plugin'
Plug 'glepnir/lspsaga.nvim'
Plug 'ray-x/lsp_signature.nvim'
Plug 'godlygeek/tabular'
Plug 'preservim/vim-markdown'
Plug 'andweeb/presence.nvim' " Discord Status
" Plug 'RRethy/vim-illuminate'
" Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'aliou/bats.vim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }
Plug 'jparise/vim-graphql'
Plug 'sunjon/shade.nvim'
Plug 'ryanoasis/vim-devicons'
Plug 'gelguy/wilder.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'mfussenegger/nvim-lint'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'folke/trouble.nvim'
Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'WhoIsSethDaniel/toggle-lsp-diagnostics.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" Git Stuff
Plug 'nvim-lua/plenary.nvim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'Juksuu/worktrees.nvim'
call plug#end()

" Key Mappings {{{

vnoremap <C-c> "+y
imap <C-v> <Esc>"+pi

" Disable spell & start :terminal
nnoremap <F3> :set nospell <bar> :term<CR>
" Insert Date (dd mm, yyyy)
inoremap <F4> <C-R>=strftime("%d %b, %Y")<CR>
nnoremap <F4> "=strftime('%d %b, %Y')<CR>P
noremap <F5> :source $MYVIMRC<CR>
nmap <F6> :NERDTreeToggle<CR>
noremap <F7> :e $MYVIMRC<CR>
noremap <F8> :call Toggle_transparent()<CR>
" Write & quit on all tabs, windows, the Kill switch
noremap <F9> :wqa<CR>
nnoremap <silent> <F10> :call PrettyMe()<CR>
inoremap <silent> <F10> :call PrettyMe()<CR>

" Visual inner line (without whitespaces)
vnoremap il :<C-U>normal ^vg_<CR>
omap il :normal vil<CR>
" Toggle code-folds
noremap <space> za
nnoremap <A-CR> :Goyo 120<CR>
" Tab to cycle through open splits
nnoremap <Tab> <C-w><C-w>
" Use Enter to switch to command mode
" nnoremap <CR> :
" Cycle through open buffers
nnoremap <S-Tab> :bn<CR>
" Use j/k to select from completion menu
" inoremap <expr> j pumvisible() ? "\<C-N>" : "j"
" inoremap <expr> k pumvisible() ? "\<C-P>" : "k"
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
nnoremap <leader>v :vsp<CR>
nnoremap <leader>h :sp<CR>
nnoremap <leader>n :enew<CR>
nnoremap <leader>z :Files ~<CR>
nnoremap <leader>fh :History<CR>
nnoremap <leader>ft :Tags<CR>
nnoremap <leader>fs :Snippets<CR>
nnoremap <leader>d :ToggleDiag <CR> :TroubleToggle<CR>

" Keep cursor centered while searching stuff
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z
nnoremap j jzz
nnoremap k kzz
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
" nnoremap <A-k> :resize +3<CR>
" nnoremap <A-j> :resize -3<CR>

" Highlight current line
noremap <A-k> :norm kV<CR>
noremap <A-j> :norm jV<CR>
"}}}

" Custom Function calls {{{
nnoremap <S-r> :call AddCmdOuput()<CR>
nnoremap t :call ToggleComment()<CR>
" Use vim-floaterm to show search results only in visual mode
xnoremap <leader>f <esc>:call SendQueryToFloatTerm()<CR>   
xnoremap <leader>t <esc>:split <bar> call SendQueryToTerm()<CR>
xnoremap <leader>s :<c-u>call SearchInternet()<CR>
"}}}

" Disable Arrow keys for good {{{
map <Left> <Nop>
map <Right> <Nop>
map <Up> <Nop>
map <Down> <Nop>
"}}}

"}}}

let s:hidden_all = 0
function! ToggleHiddenAll()
    if s:hidden_all  == 0
        let s:hidden_all = 1
        set laststatus=0
    else
        let s:hidden_all = 0
        set laststatus=2
    endif
endfunction

nnoremap <silent> <S-h> :call ToggleHiddenAll()<CR>


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
set background=dark


" Common Settings {{{
set number
set rnu
set autoindent smartindent
set expandtab
set showcmd
" set completefunc=UltiSnips#ListSnippets()
" set title
set autoread
set cursorline
set iskeyword+=-
set dictionary+=/usr/share/dict/words
set wildignorecase
set wildignore+=*/.git/*,*/site-packages/*,*/lib/*,*/bin/*,*.pyc
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg,*.avi,*.mp4,*.mkv,*.pdf,*.odt
set path+=**
set shortmess+=c
set foldcolumn=0
" set noswapfile
set lazyredraw
" set thesaurus+=/home/bhupesh/mthesaur.txt
" set shada="NONE"
set completeopt-=preview
set noshowmode
set encoding=UTF-8

" let g:python3_host_prog = '/usr/bin/python3'
let g:loaded_python_provider=0
let g:loaded_ruby_provider = 0
let g:loaded_node_provider = 0
let g:loaded_ruby_provider = 0

let g:loaded_zipPlugin=1
let g:loaded_zip=1

let g:loaded_tarPlugin=1
let g:loaded_tar=1

" Enable AutoSave on Vim startup (vim-auto-save plugin)
let g:auto_save = 1
" Load my aliases
" Sample: https://github.com/Bhupesh-V/.Varshney/blob/master/.vim_bash_env
let $BASH_ENV = "~/.vim_bash_env"
" Toggle transparent mode
let g:is_transparent = 0
" Enable syntax highlight in markdown fenced code-blocks
let g:markdown_fenced_languages = ['python', 'go', 'sh', 'sql', 'bash']

"}}}

" LSP Setup {{{

" Setup Guide: https://bhupesh.gitbook.io/notes/vim/configuring-lsp-neovim-guide

set completeopt=menuone,noselect
" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

nnoremap <silent> gd <cmd>vsplit \| lua vim.lsp.buf.definition()<CR>
" nnoremap <silent> gD <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> gi <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> gc <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> K <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <C-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> <C-n> <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> <C-p> <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
nnoremap <silent> <space>f <cmd>lua vim.lsp.buf.formatting()<CR>

autocmd BufWritePre *.py lua vim.lsp.buf.formatting_sync(nil, 100)
autocmd BufWritePre *.go lua vim.lsp.buf.formatting_sync(nil, 100)

lua <<EOF
require'lspconfig'.gopls.setup {
    on_attach = function(client)
    require 'lsp_signature'.on_attach(client)
    settings = {
      gopls = {
        staticcheck = true,
      },
    }
end,
}

require'lspconfig'.bashls.setup{}
require'lspconfig'.pyright.setup {
    on_attach = function(client)
    require 'lsp_signature'.on_attach(client)
end,
}
require'lspconfig'.dartls.setup{}
require'lsp_signature'.on_attach()
EOF

let g:compe = {}
let g:compe.enabled = v:true
let g:compe.autocomplete = v:true
let g:compe.debug = v:false
let g:compe.min_length = 1
let g:compe.preselect = 'enable'
let g:compe.throttle_time = 80
let g:compe.source_timeout = 200
let g:compe.resolve_timeout = 800
let g:compe.incomplete_delay = 400
let g:compe.max_abbr_width = 100
let g:compe.max_kind_width = 100
let g:compe.max_menu_width = 100
let g:compe.documentation = v:true

let g:compe.source = {}
let g:compe.source.path = v:true
let g:compe.source.buffer = v:true
let g:compe.source.calc = v:true
let g:compe.source.nvim_lsp = v:true
let g:compe.source.nvim_lua = v:true
" let g:compe.source.vsnip = v:true
let g:compe.source.ultisnips = v:true
" let g:compe.source.luasnip = v:true
let g:compe.source.emoji = v:true


lua <<EOF
  function go_org_imports(wait_ms)
    local params = vim.lsp.util.make_range_params()
    params.context = {only = {"source.organizeImports"}}
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end
  end
EOF

autocmd BufWritePre *.go lua go_org_imports()

" }}}

" lspsaga setup {{{

" lsp provider to find the cursor word definition and reference
nnoremap <silent> gh <cmd>lua require'lspsaga.provider'.lsp_finder()<CR>
" preview definition
nnoremap <silent> gd <cmd>lua require'lspsaga.provider'.preview_definition()<CR>
" show hover doc
nnoremap <silent> K <cmd>lua require('lspsaga.hover').render_hover_doc()<CR>
" scroll down hover doc or scroll in definition preview
nnoremap <silent> <C-f> <cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>
" scroll up hover doc
nnoremap <silent> <C-b> <cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>
" code action
nnoremap <silent><leader>ca <cmd>lua require('lspsaga.codeaction').code_action()<CR>
vnoremap <silent><leader>ca :<C-U>lua require('lspsaga.codeaction').range_code_action()<CR>

" }}}

" numb config {{{
lua require('numb').setup()
" }}}

" gitsigns config {{{
lua require('gitsigns').setup()
" }}}

" FZF Config {{{
command! -bang -nargs=? -complete=dir Files
            \ call fzf#vim#files(<q-args>, {'source': 'locate', 'options': ['--preview', '[[ -d {} ]] && tree -C {} || ~/.config/nvim/plugged/fzf.vim/bin/preview.sh {}', '--prompt', 'Open File: ', '--pointer', '🡆']}, <bang>0)
" }}}

" lightline config {{{1
" Nice lightline themes
" one
" darcula
" ayu_dark
" deus
let g:lightline = {
            \ 'colorscheme': 'one',
            \ 'separator': { 'left': '', 'right': '' },
            \ 'subseparator': { 'left': '', 'right': '' },
            \ 'component_function': { 'filetype': 'GetFiletype', 'fileformat': 'GetFileformat'},
            \ }

function! GetFiletype()
    return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
endfunction

function! GetFileformat()
    return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
endfunction

" Disable lineinfo and percent
let g:lightline.active = {
            \ 'right': [ [ 'fileformat', 'fileencoding', 'filetype' ] ] }
" }}}

" Custom Global Highlights {{{
"
" Make current line bold
highlight CursorLine cterm=bold gui=bold ctermbg=none guibg=none
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
" let g:airline_powerline_fonts = 1
" let g:airline#extensions#tabline#enabled = 1
" let g:airline#extensions#tabline#left_sep = ''
" let g:airline#extensions#tabline#formatter = 'unique_tail'
"}}}

" NERDTree config {{{
let NERDTreeMinimalUI = 1  " Disable ? etc
let NERDTreeShowHidden=1  "Show hidden files (aka dotfiles)
let NERDTreeMapActivateNode='<space>'
let NERDTreeIgnore=['\.git$']
let g:NERDTreeWinSize=20
function! DisableST()
    return " "
endfunction
au BufEnter NvimTree setlocal statusline=%!DisableST()

"}}}

" wilder config {{{
" Key bindings can be changed, see below
call wilder#setup({'modes': [':', '/', '?']})

hi PmenuSel guifg=#16e085 guibg=#253340

call wilder#set_option('renderer', wilder#popupmenu_renderer(wilder#popupmenu_border_theme({
      \ 'highlighter': wilder#basic_highlighter(),
      \ 'highlights': {
      \   'accent': wilder#make_hl('WilderAccent', 'Pmenu', [{}, {}, {'foreground': '#16e085', 'bold': v:true}]),
      \   'selected_accent': wilder#make_hl('WilderSelectedAccent', 'PmenuSel', [{}, {}, {'foreground': '#16e085', 'bold': v:true }]),
      \   'border': 'Normal',
      \ },
      \ 'border': 'rounded',
      \ 'left': [
      \   ' ', wilder#popupmenu_devicons(),
      \ ],
      \ 'right': [
      \   ' ', wilder#popupmenu_scrollbar(),
      \ ],
      \ })))

" }}}

" Floaterm config {{{

let g:floaterm_title = "bhupesh.me"
let g:floaterm_autoinsert = v:false

hi FloatermBorder cterm=bold gui=bold guibg=NONE guifg=orange
" }}}

" Ulti-snips config {{{
" let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsListSnippets="<c-l>"
" let g:UltiSnipsJumpForwardTrigger="<c-j>"
" let g:UltiSnipsJumpBackwardTrigger="<c-k>"
let g:UltiSnipsSnippetDirectories=["UltiSnips", "vim-snippets", $HOME.'/Documents/.Varshney/snippets/']
" }}}

" vim-devicons config {{{
" loading the plugin
let g:webdevicons_enable = 1
" adding to vim-airline's statusline
let g:WebDevIconsOS = 'Linux'
" }}}

" null-ls.nvim config {{{

lua << EOF
  require("trouble").setup {
  }
EOF

lua << EOF
require("null-ls").setup({
    sources = {
        require("null-ls").builtins.diagnostics.vale,
    },
})
EOF

" }}}

lua <<EOF
require'toggle_lsp_diagnostics'.init()
require'worktrees'.setup()
require("telescope").load_extension("worktrees")

require("presence"):setup({
    -- General options
    auto_update         = true,                       -- Update activity based on autocmd events (if `false`, map or manually execute `:lua package.loaded.presence:update()`)
    neovim_image_text   = "The One True Text Editor", -- Text displayed when hovered over the Neovim image
    main_image          = "neovim",                   -- Main image display (either "neovim" or "file")
    client_id           = "793271441293967371",       -- Use your own Discord application client id (not recommended)
    log_level           = nil,                        -- Log messages at or above this level (one of the following: "debug", "info", "warn", "error")
    debounce_timeout    = 10,                         -- Number of seconds to debounce events (or calls to `:lua package.loaded.presence:update(<filename>, true)`)
    enable_line_number  = false,                      -- Displays the current line number instead of the current project
    blacklist           = {},                         -- A list of strings or Lua patterns that disable Rich Presence if the current file name, path, or workspace matches
    buttons             = true,                       -- Configure Rich Presence button(s), either a boolean to enable/disable, a static table (`{{ label = "<label>", url = "<url>" }, ...}`, or a function(buffer: string, repo_url: string|nil): table)
    file_assets         = {},                         -- Custom file asset definitions keyed by file names and extensions (see default config at `lua/presence/file_assets.lua` for reference)

    -- Rich Presence text options
    editing_text        = "Editing %s",               -- Format string rendered when an editable file is loaded in the buffer (either string or function(filename: string): string)
    file_explorer_text  = "Browsing %s",              -- Format string rendered when browsing a file explorer (either string or function(file_explorer_name: string): string)
    git_commit_text     = "Committing changes",       -- Format string rendered when committing changes in git (either string or function(filename: string): string)
    plugin_manager_text = "Managing plugins",         -- Format string rendered when managing plugins (either string or function(plugin_manager_name: string): string)
    reading_text        = "Reading %s",               -- Format string rendered when a read-only or unmodifiable file is loaded in the buffer (either string or function(filename: string): string)
    workspace_text      = "Working on %s",            -- Format string rendered when in a git repository (either string or function(project_name: string|nil, filename: string): string)
    line_number_text    = "Line %s out of %s",        -- Format string rendered when `enable_line_number` is set to true (either string or function(line_number: number, line_count: number): string)
})
EOF

" Auto Commands {{{

" Set foldmethod based on file type
augroup FoldMethodType
    autocmd!
    autocmd FileType python,css,javascript,go,html,sh,json setlocal foldmethod=syntax
    autocmd FileType vim setlocal foldmethod=marker
augroup END

" Set Indent level based on FileType
augroup FileIndentLevel
    autocmd!
    autocmd FileType htmldjango,cpp,yaml,html,css setlocal shiftwidth=2 tabstop=2 softtabstop=2
    autocmd FileType go,python,vim,sh,json setlocal tabstop=4 sts=4 shiftwidth=4
augroup END

" Map Caps Lock to Esc (must be X.Org compliant)
au VimEnter * silent! !xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'
au VimLeave * silent! !xmodmap -e 'clear Lock' -e 'keycode 0x42 = Caps_Lock'

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

" My Plugins {{{

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

" Run commands inside the editor & paste output in next line
function! AddCmdOuput()
    try
        let cmd_output = systemlist(getline("."))
        echo "Executing " . getline(".")[0:3] . " ... "

        let command_list = split(getline("."), " ")
        if command_list[0] == "curl"

        endif
        call append(line('.'), '```')
        call append(line('.'), cmd_output)
        call append(line('.'), '```')
    catch E684
        echo "Not a command"
        return
        if stridx(cmd_output[0], "command not found") == -1
            call append(line('.') + 1, cmd_output)
        else
            " redraw
            " echo "⚠️  " . getline(".")[0:3] . ".. not found"
        endif
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
        silent exe "!pj %:p"
    elseif &filetype == "python"
        silent exe ":Black"
    elseif &filetype == "go"
        " Add missing imports and lint stuff
        silent exe ":!goimports -w % && gofmt -w -s %"
    else
        " Indent and Go back to my previous cursor pos
        silent exe "norm! gg=G\<C-o>"
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
" }}}


if (has("termguicolors"))
    let $NVIM_TUI_ENABLE_TRUE_COLOR = 1
    set termguicolors
endif
