return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"mason-org/mason.nvim",
		},
	},
	-- LiveScript language server for SiTest development
	{ "gkz/vim-ls", lazy = false },
}
