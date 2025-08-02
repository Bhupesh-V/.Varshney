return {
  "Shatur/neovim-ayu",
  priority = 1000,
  lazy = false, -- Load immediately
  config = function()
    require("ayu").setup({
        mirage = true,
    })
  end,
}