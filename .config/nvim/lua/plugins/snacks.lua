return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {},
	keys = {
		{
			"<leader>bd",
			function()
				Snacks.bufdelete()
			end,
			desc = "Delete Buffer (ウィンドウ維持)",
		},
		{
			"<leader>bD",
			function()
				Snacks.bufdelete()
			end,
			desc = "Delete Buffer Force",
		},
	},
}
