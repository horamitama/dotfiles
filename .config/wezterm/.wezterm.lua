local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.initial_cols = 120
config.initial_rows = 50

config.font = wezterm.font_with_fallback({
	{ family = "Hack Nerd Font", weight = "Medium" },
	{ family = "Hiragino Kaku Gothic ProN", weight = "Medium" },
})
config.font_size = 15

config.color_scheme = "nord"
-- config.harfbuzz_features = { "calt=0", "clig=0", "liga=0", "zero" }
config.adjust_window_size_when_changing_font_size = false

config.window_background_opacity = 0.85
config.scrollback_lines = 3500
config.enable_scroll_bar = true
-- config.window_decorations = "RESIZE"

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
