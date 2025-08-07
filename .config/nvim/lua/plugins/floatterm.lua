return {
    "voldikss/vim-floaterm",
    cmd = {"FloatermToggle", "FloatermNew", "FloatermShow", "FloatermHide"},
    config = function()
        -- hi FloatermBorder cterm=bold gui=bold guibg=NONE guifg=orange
        vim.api.nvim_set_hl(0, "FloatermBorder", {
            bold = true,
            bg = "NONE",
            fg = "orange"
        })
    end
}