-- Module for configuring Lua specific buffer

-- Start the Treesitter parser process
vim.treesitter.start()
-- Enable and configure the LSP server
vim.lsp.enable("lua_ls", true)
