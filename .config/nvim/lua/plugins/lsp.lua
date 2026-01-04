return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		build = ":MasonUpdate",
		opts = {},
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		dependencies = { "mason.nvim" },
		opts = {
			ensure_installed = {
				"lua_ls",
				"ts_ls",
			},
			automatic_installation = true,
		},
	},
}
