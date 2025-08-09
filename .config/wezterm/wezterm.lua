-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices.

--config.initial_cols = 120
--config.initial_rows = 28
config.window_decorations = "RESIZE"

config.font_size = 20
config.color_scheme = 'Ayu Mirage'
config.font = wezterm.font 'FiraCode Nerd Font'

-- Remove extra padding
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}
config.window_frame = {
    active_titlebar_bg = '#090909',
}

config.animation_fps = 120
config.cursor_blink_ease_in = 'EaseOut'
config.cursor_blink_ease_out = 'EaseOut'
config.default_cursor_style = 'BlinkingBlock'
config.cursor_blink_rate = 650
config.window_background_opacity = 0.7  -- 0.0 = fully transparent, 1.0 = opaque
config.text_background_opacity = 1.0     -- keep text solid
config.macos_window_background_blur = 20
config.line_height = 1.0 -- or slightly less, e.g., 0.95

config.colors = {
  cursor_bg = '#5DFFFF',
  cursor_fg = '#1E1E1E',
}

wezterm.on("gui-startup", function(cmd)
  local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
  window:gui_window():toggle_fullscreen()
end)


-- Finally, return the configuration to wezterm:
return config
