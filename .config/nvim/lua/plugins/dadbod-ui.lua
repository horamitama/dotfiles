return {
	"kristijanhusak/vim-dadbod-ui",
	dependencies = {
		{ "tpope/vim-dadbod", lazy = true },
		{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true }, -- Optional
	},
	cmd = {
		"DBUI",
		"DBUIToggle",
		"DBUIAddConnection",
		"DBUIFindBuffer",
	},
	keys = {
		{ "<leader>d", "<cmd>DBUIToggle<cr>", desc = "Toggle DBUI" },
	},
	init = function()
		local mysql_path = "/opt/homebrew/opt/mysql-client@8.0/bin"

		-- もしそのディレクトリが存在するなら、PATHの先頭に追加する
		if vim.fn.isdirectory(mysql_path) == 1 then
			vim.env.PATH = mysql_path .. ":" .. vim.env.PATH
		end

		-- ついでにDadbodの便利設定もここに書いておくと管理しやすいです
		vim.g.db_ui_use_nerd_fonts = 1
		vim.g.db_ui_show_database_icon = 1
		-- Your DBUI configuration
		vim.g.db_ui_use_nerd_fonts = 1
		vim.g.db_ui_win_position = "right"
		vim.g.db_ui_winwidth = 30 -- Optional: adjust the width (default is 40)
	end,
}
