return {
    "nvim-tree/nvim-tree.lua",
    lazy = false,
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
                dotfiles = false
            }
        })
        --    -- Auto-open NvimTree on startup
        -- local function open_nvim_tree(data)
        --     -- Ignore if it's a directory
        --     if vim.fn.isdirectory(data.file) == 1 then
        --         require("nvim-tree.api").tree.open()
        --         return
        --     end
        --     -- For normal files
        --     require("nvim-tree.api").tree.open()
        -- end

        -- vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
    end
}
