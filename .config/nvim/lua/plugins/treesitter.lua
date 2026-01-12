return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	-- enabled = false,
	build = ":TSUpdate",
	opts = {
		ensure_installed = {
			"lua",
			"typescript",
			"tsx",
			"javascript",
			"yaml",
			"html",
			"css",
			"markdown",
			"markdown_inline",
			"bash",
			"json",
			"terraform",
			"hcl",
		},
		auto_install = true,
		highlight = {
			enable = true,
		},
		indent = {
			enable = true,
		},
	},
}
