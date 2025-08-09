-- Module for configuring the statusline plugin - "lualine"
return {
    "nvim-lualine/lualine.nvim",
    -- This needs to be loaded after the "VeryLazy" event otherwise an ugly
    -- unstyled statusline is created after Neovim startup
    event = "VeryLazy",
    opts = {
        -- Leaving an empty table renders the square-edged components, else the default angled ones are loaded
        section_separators = {
            left = '',
            right = ''
        },
        component_separators = {
            left = '',
            right = ''
        },
        --theme = "horizon",
        globalstatus = true,
        disabled_filetypes = {
            statusline = { "dashboard", "filesytem", "mason", "neo-tree", "neo-tree-popup", "null-ls-info", "lazy",
                "lspinfo", "ministarter", "TelescopePrompt" }
        }
    },
    config = function(_, opts)
        local sections = {
            -- Statusline components to showcase on the right-most end
            lualine_x = { "filetype" },
            -- add "progress" to lualine_y to show file scroll percentage
            lualine_y = { "" },
            lualine_z = { "location" },
            lualine_c = { "filename" }
            -- lualine_c = { -- INFO: This section shows the entire filepath relative to the project root
            --   { "filename", path = 1 },
            -- },
        }

        require("lualine").setup({
            options = opts,
            sections = sections
        })
    end,
    disable = false
}
