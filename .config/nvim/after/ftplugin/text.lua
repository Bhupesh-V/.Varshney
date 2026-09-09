-- Filetype plugin which applies settings only for plain text files

-- Custom <C-x><C-t> thesaurus completion (hides the source-file path that
-- Neovim's default thesaurus completion shows next to every match)
vim.bo.thesaurusfunc = "v:lua.require'thesaurus_source'.complete"
