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
            }
        })
    end
}
