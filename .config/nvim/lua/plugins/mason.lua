return {
	{
		"mason-org/mason.nvim",
		lazy = false,
		build = ":MasonUpdate",
		opts = {},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		lazy = false,
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"neovim/nvim-lspconfig",
		},
		opts = {
			automatic_enable = false,
			ensure_installed = {
				"lua_ls",
				"vtsls",
				"jdtls",
				"yamlls",
				"gopls",
				"terraformls",
				"pyright",
			},
		},
	},
}
