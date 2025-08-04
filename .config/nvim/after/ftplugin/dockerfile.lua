-- Start the Treesitter parsing process for Dockerfile
vim.treesitter.start()

-- Enable the "dockerls" LSP server for Dockerfile
vim.lsp.enable("dockerls", true)
