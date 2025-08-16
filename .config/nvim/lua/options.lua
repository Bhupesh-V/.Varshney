local opt = vim.opt
opt.number = true
opt.relativenumber = true
opt.autoindent = true
opt.smartindent = true
opt.expandtab = true
opt.showcmd = true
opt.autoread = true
opt.cursorline = true
opt.iskeyword:append("-")
opt.wildignorecase = true
opt.wildignore = {
	"*.jpg",
	"*.bmp",
	"*.gif",
	"*.png",
	"*.jpeg",
	"*.avi",
	"*.mp4",
	"*.mkv",
	"*.pdf",
	"*.odt",
	"*/.git/*",
	"*/site-packages/*",
	"*/lib/*",
	"*/bin/*",
	"*.pyc",
}
opt.path:append("**")
opt.shortmess:append("c")
opt.dictionary:append("/usr/share/dict/words")
opt.lazyredraw = true
opt.completeopt = "menuone,noselect"
opt.encoding = "UTF-8"
opt.termguicolors = true
opt.background = "dark"
-- disable NVIM start message
opt.shortmess:append("I")

vim.g.netrw_banner = 0 -- disable annoying banner
vim.g.netrw_liststyle = 3 -- tree view
vim.g.netrw_browse_split = 2 -- Open file in new vertical split
vim.g.netrw_preview = 1
vim.g.netrw_altv = 1
vim.g.netrw_winsize = 27 -- Fix width to 27%
vim.g.netrw_special_syntax = 1 -- Enable special file highlighting
vim.g.netrw_browsex_viewer = "xdg-open"

vim.o.tabstop = 4 -- A TAB character looks like 4 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 4 -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 4 -- Number of spaces inserted when indenting

