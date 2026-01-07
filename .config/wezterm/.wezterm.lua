local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.initial_cols = 120
config.initial_rows = 50
config.window_background_opacity = 0.85
config.macos_window_background_blur = 20
config.color_scheme = "nord"
config.use_ime = true

config.font = wezterm.font_with_fallback({
	{ family = "Hack Nerd Font", weight = "Medium" },
	{ family = "Hiragino Kaku Gothic ProN", weight = "Medium" },
})
config.font_size = 14

config.adjust_window_size_when_changing_font_size = false
-- config.window_decorations = "RESIZE"

-- 外付けディスプレイでのスリープ復帰問題対策
config.native_macos_fullscreen_mode = false
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false

-- ウィンドウサイズ復元イベント
wezterm.on("window-resized", function(window, pane)
	local overrides = window:get_config_overrides() or {}
	window:set_config_overrides(overrides)
end)

config.hide_tab_bar_if_only_one_tab = false
config.window_frame = {
	inactive_titlebar_bg = "none",
	active_titlebar_bg = "none",
}
config.show_new_tab_button_in_tab_bar = false
config.colors = {
	tab_bar = {
		inactive_tab_edge = "none",
	},
}

local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_lower_right_triangle
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_upper_left_triangle
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local background = "#4c566a"
	local foreground = "#FFFFFF"
	local edge_background = "none"

	if tab.is_active then
		background = "#88c0d0"
		foreground = "#FFFFFF"
	end
	local edge_foreground = background

	local title = "   " .. wezterm.truncate_right(tab.active_pane.title, max_width - 1) .. "   "

	return {
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_LEFT_ARROW },
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = title },
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_RIGHT_ARROW },
	}
end)
config.window_background_gradient = {
	colors = { "#2e3440" },
}

config.keys = require("keybinds").keys
config.key_tables = require("keybinds").key_tables
config.disable_default_key_bindings = true
config.leader = { key = "g", mods = "CTRL", timeout_milliseconds = 2001 }

return config
