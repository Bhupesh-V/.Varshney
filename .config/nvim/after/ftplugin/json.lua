-- Start the Treesitter parsing process
vim.treesitter.start()

-- Start the "jsonls" LSP server
vim.lsp.enable("jsonls", true)
