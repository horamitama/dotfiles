return {
	-- バッファ内インライン描画
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown", "codecompanion" },
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.icons" },
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {
			completions = { lsp = { enabled = true } },
			heading = { sign = false, position = "inline" },
			code = { sign = false, width = "block", right_pad = 2 },
			checkbox = { enabled = true },
		},
	},

	-- ブラウザプレビュー
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
		ft = { "markdown" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
			vim.g.mkdp_theme = "dark" -- nord に合わせる
			vim.g.mkdp_auto_close = 0 -- バッファを閉じてもプレビューを残す
		end,
		keys = {
			{ "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", ft = "markdown", desc = "Markdown Preview (browser)" },
		},
	},
}
