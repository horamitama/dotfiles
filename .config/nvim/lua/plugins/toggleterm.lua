return {
	"akinsho/toggleterm.nvim",
	version = "*",
	opts = {
		size = 20,
		open_mapping = [[<c-/>]], -- これで Ctrl + \ で開閉できるようになります
		hide_numbers = true,
		shade_filetypes = {},
		shade_terminals = true,
		shading_factor = 2,
		start_in_insert = true,
		insert_mappings = true,
		persist_size = true,
		-- 【重要】ここで表示方法を選べます
		-- 'vertical' (右), 'horizontal' (下), 'tab' (タブ), 'float' (浮く)
		direction = "float",
		close_on_exit = true,
		shell = vim.o.shell,
		float_opts = {
			border = "curved", -- 角丸の枠線
			winblend = 0,
		},
	},
	keys = {
		-- Ctrl + \ でトグル（表示/非表示）する設定
		{ "<C-/>", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal" },

		-- もし「右側」に出したい時専用のキーも作りたいならこれ
		{ "<leader>tv", "<cmd>ToggleTerm size=80 direction=vertical<cr>", desc = "Terminal (Vertical)" },
	},
}
