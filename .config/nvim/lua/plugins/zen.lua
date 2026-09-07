return {
    "folke/zen-mode.nvim",
    cmd = {"ZenMode"},
    config = function()
        require("zen-mode").setup({
            window = {
                backdrop = 0.95, -- Darkens the background
                width = 120, -- Width of the Zen window
                height = 1, -- Height of the Zen window
                options = {
                    signcolumn = "no", -- Disable sign column
                    number = false, -- Disable line numbers
                    relativenumber = false, -- Disable relative line numbers
                    cursorline = false, -- Disable cursor line
                    foldcolumn = "0", -- Disable fold column
                    laststatus = 0, -- Disable last status line
                    showcmd = false
                }
            },
            -- Force a full screen clear/repaint so leftover characters from
            -- the wider layout don't stay ghosted in the reclaimed gutter.
            -- Deferred via vim.schedule: zen-mode still runs its own layout
            -- fixup (fix_layout) after on_open/on_close fire, so redrawing
            -- immediately happens before the layout actually settles.
            on_open = function()
                vim.schedule(function()
                    vim.cmd("redraw!")
                end)
            end,
            on_close = function()
                vim.schedule(function()
                    vim.cmd("redraw!")
                end)
            end
        })
    end
}
