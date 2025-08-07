-- Module for configuring the plugin for smooth scrolling
-- https://github.com/karb94/neoscroll.nvim

return {
  "karb94/neoscroll.nvim",
  event = { "BufRead", "BufNewFile" },
  opts = {
    respect_scrolloff = true,
    cursor_scrolls_alone = false,
    easing = "quadratic" -- default: linear
    -- linear, quadratic, cubic, quartic, quintic, circular, sine
  },
  config = function(_, opts)
    require("neoscroll").setup(opts)
  end,
}
