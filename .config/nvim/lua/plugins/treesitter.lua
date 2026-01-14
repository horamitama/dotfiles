return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		-- パーサーのインストール
		local parsers = {
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
		}
		require("nvim-treesitter").install(parsers)

		-- treesitter highlight を全ファイルタイプで有効化
		vim.api.nvim_create_autocmd("FileType", {
			callback = function()
				pcall(vim.treesitter.start)
			end,
		})

		-- treesitter indent を有効化
		vim.api.nvim_create_autocmd("FileType", {
			callback = function()
				if pcall(vim.treesitter.get_parser) then
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end
			end,
		})
	end,
}
