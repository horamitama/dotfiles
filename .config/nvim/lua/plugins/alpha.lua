return {
	"goolord/alpha-nvim",
	lazy = false,
	dependencies = {
		"nvim-mini/mini.icons",
		"nvim-lua/plenary.nvim",
	},
	config = function()
		require("alpha").setup(require("alpha.themes.theta").config)
	end,
}

print("hoge")
