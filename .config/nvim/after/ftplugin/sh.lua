-- Start the Treesitter parser for Shell files
vim.treesitter.start()

-- Start the "bashls" LSP server for Bash scripting
vim.lsp.enable("bashls", true)
