-- Filetype plugin which applies settings only for Markdown files

vim.opt.wrap = true -- Wrap lines instead of continuing on beyond the limits of the monitor
vim.opt.linebreak = true -- Wrap the lines at the end of a word instead of the last character of a line

-- Underline misspelled words (]s/[s to jump, z= for suggestions, zg to add a word)
vim.opt.spell = true
vim.opt.spelllang = "en_us"

-- Enable the "vale-ls" LSP server for Markdown files
vim.lsp.enable("vale-ls", true)

-- Start the Treesitter parsing process
vim.treesitter.start()

-- Custom <C-x><C-t> thesaurus completion (hides the source-file path that
-- Neovim's default thesaurus completion shows next to every match)
vim.bo.thesaurusfunc = "v:lua.require'thesaurus_source'.complete"
