-- Start the Treesitter parsing logic
vim.treesitter.start()

-- INFO: Only open "massive" buffers with folds enabled
if vim.api.nvim_buf_line_count(0) >= 100 then
  vim.opt.foldmethod = "indent"
  vim.opt.foldlevel = 1
  vim.opt.foldenable = true
end

-- Start the "yamlls" LSP server
vim.lsp.enable("yamlls", true)
