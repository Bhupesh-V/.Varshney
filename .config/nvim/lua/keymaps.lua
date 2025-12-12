-- keymaps.lua

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Leader key
vim.g.mapleader = " "

-- Terminal mode escape
map("t", "<Esc>", "<C-\\><C-n>", opts)

-- File explorer
map("n", "<leader>n", ":NvimTreeToggle<CR>", opts)

-- Terminal
--map("n", "<leader>t", ":FloatermToggle<CR>", opts)

-- Save & quit
map("n", "<leader>w", ":w<CR>", opts)
map("n", "<leader>q", ":q<CR>", opts)
map("n", "<leader>x", ":x<CR>", opts)

-- Clear search
map("n", "<leader>c", ":nohlsearch<CR>", opts)

-- Toggle Goyo mode
-- map("n", "<leader>z", ":Goyo<CR>", opts)

-- FZF Lua
map("n", "<leader>f", ":FzfLua files<CR>", opts)
map("n", "<leader>g", ":FzfLua live_grep<CR>", opts)
map("n", "<leader>b", ":FzfLua buffers<CR>", opts)
map("n", "<leader>c", ":FzfLua colorschemes<CR>", opts)

-- Activate Command Mode using ";"
map("n", ";", ":")

-- Resize split windows
map("n", "<A-h>", ":vertical resize +3<CR>")
map("n", "<A-l>", ":vertical resize -3<CR>")

-- Cycle through open buffers
map("n", "<S-Tab>", ":bn<CR>")

-- Tab to cycle through open splits
map("n", "<Tab>", "<C-w><C-w>")

-- Copy using ctrl + c
map("v", "<C-c>", '"+y')
map("v", "<A-c>", '"+y')
map("i", "<C-v>", '<Esc>"+pi')

-- vertical split
map("n", "<leader>v", ":vsp<CR>")

-- horizontal split
map("n", "<leader>s", ":sp<CR>")

-- new tab
map("n", "<leader>t", ":tabnew<CR>")

-- Visual inner line (without whitespaces) - slightly better than shift+v
map("v", "il", ":<C-U>normal ^vg_<CR>")
