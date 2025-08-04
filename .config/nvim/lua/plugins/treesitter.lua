return {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    lazy = false,
    priority = 100,
    build = ":TSUpdate",
    config = function()
        local ok, treesitter = pcall(require, "nvim-treesitter.configs")
        if not ok then
            return
        end

        treesitter.setup({
            ensure_installed = {
                "bash", "comment", "css", "diff", "dockerfile", "git_rebase", "gitattributes",
                "gitcommit", "gitignore", "go", "gomod", "gosum", "hcl", "html", "javascript", "jinja",
                "jsdoc", "json", "lua", "make", "markdown", "markdown_inline", "mermaid", "python",
                "regex", "rst", "scss", "terraform", "toml", "typescript", "yaml", "vim", "vimdoc"
            },
            sync_install = false,
            auto_install = true,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
        })
    end,
}