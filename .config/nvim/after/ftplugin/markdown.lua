-- Filetype plugin which applies settings only for Markdown files

vim.opt.wrap = true -- Wrap lines instead of continuing on beyond the limits of the monitor
vim.opt.linebreak = true -- Wrap the lines at the end of a word instead of the last character of a line

-- Enable the "vale-ls" LSP server for Markdown files
vim.lsp.enable("vale-ls", true)

-- Start the Treesitter parsing process
vim.treesitter.start()
