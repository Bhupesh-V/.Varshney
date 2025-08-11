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
map("n", "<leader>t", ":FloatermToggle<CR>", opts)

-- Save & quit
map("n", "<leader>w", ":w<CR>", opts)
map("n", "<leader>q", ":q<CR>", opts)
map("n", "<leader>x", ":x<CR>", opts)

-- Better navigation
map("n", "<C-j>", "<C-W>j", opts)
map("n", "<C-k>", "<C-W>k", opts)
map("n", "<C-h>", "<C-W>h", opts)
map("n", "<C-l>", "<C-W>l", opts)

-- Clear search
map("n", "<leader>c", ":nohlsearch<CR>", opts)

-- Toggle Goyo mode
-- map("n", "<leader>z", ":Goyo<CR>", opts)

-- Telescope
map("n", "<leader>f", ":Telescope fd<CR>", opts)
-- map("n", "<leader>g", ":Telescope live_grep<CR>", opts)
map("n", "<leader>b", ":Telescope buffers<CR>", opts)
map("n", "<leader>h", ":Telescope help_tags<CR>", opts)
map("n", "<leader>c", ":Telescope colorscheme<CR>", opts)
map("n", "<leader>d", ":Telescope diagnostics<CR>", opts)

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
map("i", "<C-v>", '<Esc>"+pi')
