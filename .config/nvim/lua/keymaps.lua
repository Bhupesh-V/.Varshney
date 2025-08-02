-- keymaps.lua

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Leader key
vim.g.mapleader = " "

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
map("n", "<leader>z", ":Goyo<CR>", opts)

-- Telescope
map("n", "<leader>f", ":Telescope find_files<CR>", opts)
map("n", "<leader>g", ":Telescope live_grep<CR>", opts)
map("n", "<leader>b", ":Telescope buffers<CR>", opts)
map("n", "<leader>h", ":Telescope help_tags<CR>", opts)
