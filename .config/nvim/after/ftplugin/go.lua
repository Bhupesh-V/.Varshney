-- Module for configuring Golang filetypes

local autocmd = require("utils").autocmd
local augroup = require("utils").augroup
local map = require("utils").map

autocmd("BufWritePost", {
  desc = "Format the buffer contents after save",
  group = augroup("format_go_files"),
  callback = function()
    require("lint").try_lint()
  end,
})

map("n", "<F5>", "<CMD>terminal go run %<CR>")

-- Configure the indent-based folds for Go buffers
if vim.api.nvim_buf_line_count(0) >= 100 then
  vim.opt.foldmethod = "expr"
  vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
  vim.opt.foldlevel = 0 -- Start with folds closed
  vim.opt.foldcolumn = "auto" -- Show fold indicators on the left margin
  vim.opt.foldnestmax = 99 -- Maximum depth of folds
end

-- Start the Treesitter parsing process
vim.treesitter.start()

-- ...existing code...

-- Start the "gopls" LSP server
vim.lsp.enable("gopls", true)

-- Add LSP keybindings for Go files
local telescope = require("telescope.builtin")

map("n", "gd", telescope.lsp_definitions, {
    desc = "Jump to the object definition"
})
map("n", "gD", vim.lsp.buf.declaration, {
    desc = "Jump to the object declaration"
})
map("n", "gT", telescope.lsp_type_definitions, {
    desc = "Get the type documentations"
})
map("n", "gi", vim.lsp.buf.implementation, {
    desc = "Jump to the implementation"
})
map("n", "K", vim.lsp.buf.hover, {
    desc = "Open the documentations of the object"
})
map("n", "<C-S>", vim.lsp.buf.signature_help, {
    desc = "Get the help documentations"
})
map("n", "gr", vim.lsp.buf.rename, {
    desc = "Rename the object under the cursor"
})
map("n", "gR", telescope.lsp_references, {
    desc = "Jump to the reference of the object"
})
map("n", "gra", vim.lsp.buf.code_action, {
    desc = "Open available code actions"
})

require("snippets.go")