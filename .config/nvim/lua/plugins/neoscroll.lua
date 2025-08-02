-- Module for configuring the plugin for smooth scrolling

return {
  "karb94/neoscroll.nvim",
  event = { "BufRead", "BufNewFile" },
  opts = {
    respect_scrolloff = true,
    cursor_scrolls_alone = false,
  },
  config = function(_, opts)
    require("neoscroll").setup(opts)
  end,
}
