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
				"vtsls",
				"jdtls",
				"yamlls",
				"gopls",
				"terraformls",
				"pyright",
			},
			automatic_installation = true,
		},
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		dependencies = {
			"mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
		config = function()
			-- Load LSP configurations
			require("config.lsp.init")
		end,
	},
	{ "gkz/vim-ls", lazy = false },
}
