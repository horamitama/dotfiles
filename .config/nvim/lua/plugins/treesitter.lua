return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate", -- 自動更新はここでやるので、configの中には書かない
	event = { "BufReadPost", "BufNewFile" },
	init = function(plugin)
		-- クエリ関連のハック（LazyVim由来のものがあれば残す）
		require("lazy.core.loader").add_to_rtp(plugin)
		require("nvim-treesitter.query_predicates")
	end,
	-- mainのconfig関数
	config = function()
		require("nvim-treesitter.configs").setup({
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
			},
			-- 自動インストールを有効にする
			auto_install = true,
			highlight = {
				enable = true,
			},
			indent = {
				enable = true,
			},
		})
	end,
}
