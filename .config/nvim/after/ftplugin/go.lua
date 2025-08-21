-- Module for configuring Go

-- Start the Treesitter parsing process
vim.treesitter.start()
-- Start the "gopls" LSP server
vim.lsp.enable("gopls", true)

-- Configure the indent-based folds for Go buffers
if vim.api.nvim_buf_line_count(0) >= 100 then
	vim.opt.foldmethod = "expr"
	vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
	vim.opt.foldlevel = 0 -- Start with folds closed
	vim.opt.foldcolumn = "auto" -- Show fold indicators on the left margin
	vim.opt.foldnestmax = 99 -- Maximum depth of folds
end
