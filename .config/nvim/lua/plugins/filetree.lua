return {
    "nvim-tree/nvim-tree.lua",
    dependencies = {"nvim-tree/nvim-web-devicons"},
    cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeFocus" },
    config = function()
        -- Disable netrw
        -- vim.g.loaded_netrw = 1
        -- vim.g.loaded_netrwPlugin = 1
        
        require("nvim-tree").setup({
            sort = {
                sorter = "case_sensitive"
            },
            view = {
                width = 30
            },
            renderer = {
                group_empty = true
            },
            filters = {
                dotfiles = true
            }
        })
    end
}