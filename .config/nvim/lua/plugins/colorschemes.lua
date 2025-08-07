return {{
    "Shatur/neovim-ayu",
    priority = 1000,
    lazy = false, -- Load immediately
    config = function()
        require("ayu").setup({
            mirage = true
        })
    end
}, {
    "sainnhe/sonokai",
    priority = 1000,
    lazy = false

}, {
    "franbach/miramare",
    priority = 1000,
    lazy = false
}, {
    "NLKNguyen/papercolor-theme",
    priority = 1000,
    lazy = false
}, {
    "drewtempelmeyer/palenight.vim",
    priority = 1000,
    lazy = false
}, {
    "lifepillar/vim-gruvbox8",
    priority = 1000,
    lazy = false
}}
