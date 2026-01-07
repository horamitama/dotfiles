return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	lazy = false,
	config = function()
		require("nvim-treesitter").setup({
			install_dir = vim.fn.stdpath("data") .. "/site",
		})
		-- パーサーをインストール
		require("nvim-treesitter").install({
			"lua",
			"typescript",
			"tsx",
			"javascript",
			"go",
			"html",
			"css",
			"json",
			"yaml",
			"markdown",
			"markdown_inline",
			"bash",
			"vim",
			"vimdoc",
			"python",
		})
		-- ハイライトを有効化
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "*",
			callback = function()
				pcall(vim.treesitter.start)
			end,
		})
	end,
}
