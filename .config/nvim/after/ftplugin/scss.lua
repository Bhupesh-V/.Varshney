-- Start the Treesitter parsing process for SASS files
vim.treesitter.start()

-- Start the LSP server for the SASS files
vim.lsp.enable("cssls", true)
