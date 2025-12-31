local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.initial_cols = 120
config.initial_rows = 50
config.window_background_opacity = 0.85
config.macos_window_background_blur = 10
config.color_scheme = "nord"
config.use_ime = true

config.font = wezterm.font_with_fallback({
	{ family = "Hack Nerd Font", weight = "Medium" },
	{ family = "Hiragino Kaku Gothic ProN", weight = "Medium" },
})
config.font_size = 14

config.adjust_window_size_when_changing_font_size = false
config.window_decorations = "RESIZE"

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

-- ---------------------------------------------------------
-- キーバインド設定（画面分割など）
-- ---------------------------------------------------------

-- 「リーダーキー」を設定します
-- これを押してから、別のキーを押すことでコマンドを実行します
-- ここでは「Ctrl + a」をリーダーキーに設定しています（tmux風）
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }

config.keys = {
	-- [Ctrl + a] -> [-] で画面を上下に分割
	{
		key = "-",
		mods = "LEADER",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	-- [Ctrl + a] -> [|] (Shift + \) で画面を左右に分割
	{
		key = "|",
		mods = "LEADER|SHIFT",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	-- [Ctrl + a] -> [x] で現在のパネルを閉じる
	{
		key = "x",
		mods = "LEADER",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},
	-- [Ctrl + a] -> [h/j/k/l] でパネル間を移動（Vim風）
	{ key = "h", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Left") },
	{ key = "l", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Right") },
	{ key = "k", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Up") },
	{ key = "j", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Down") },
	{
		key = "P",
		mods = "CTRL",
		action = wezterm.action.ActivateCommandPalette,
	},
}
config.mouse_bindings = {
	-- Cmdキー(WindowsならCtrl)を押しながらクリックするとリンクを開く
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CMD",
		action = wezterm.action.OpenLinkAtMouseCursor,
	},
}

return config
