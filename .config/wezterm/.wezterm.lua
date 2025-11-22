local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.initial_cols = 120
config.initial_rows = 28

config.font = wezterm.font("Hack Nerd Font", { weight = "Regular", stretch = "Normal", style = "Normal" })
config.font_size = 15

config.color_scheme = "nord"
-- config.harfbuzz_features = { "calt=0", "clig=0", "liga=0", "zero" }

config.window_background_opacity = 0.95
config.scrollback_lines = 3500
config.enable_scroll_bar = true
config.window_decorations = "RESIZE"

return config
