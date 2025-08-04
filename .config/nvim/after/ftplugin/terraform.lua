-- Set the correct comment string format for Terraform files
vim.opt.commentstring = "// %s"

-- Start the Treesitter parsing process
vim.treesitter.start()

-- Start the "terraform-ls" LSP server
vim.lsp.enable("terraformls", true)
