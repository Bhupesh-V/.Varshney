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
  "*.jpg", "*.bmp", "*.gif", "*.png", "*.jpeg", "*.avi", "*.mp4", "*.mkv", "*.pdf", "*.odt",
  "*/.git/*", "*/site-packages/*", "*/lib/*", "*/bin/*", "*.pyc"
}
opt.path:append("**")
opt.shortmess:append("c")
opt.lazyredraw = true
opt.completeopt = "menuone,noselect"
opt.encoding = "UTF-8"
opt.termguicolors = true
opt.background = "dark"
