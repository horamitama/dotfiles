return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		{
			"SmiteshP/nvim-navic",
			config = function()
				local navic = require("nvim-navic")
				navic.setup({ highlight = true })
				-- auto_attach だと term:// バッファの URI が LSP に送られ terraform-ls が panic するため通常ファイルに限定
				vim.api.nvim_create_autocmd("LspAttach", {
					callback = function(args)
						local client = vim.lsp.get_client_by_id(args.data.client_id)
						if
							client
							and client:supports_method("textDocument/documentSymbol")
							and vim.bo[args.buf].buftype == ""
						then
							navic.attach(client, args.buf)
						end
					end,
				})
			end,
		},
	},
	opts = {
		options = {
			theme = "nord",
			globalstatus = true,
			component_separators = { left = "", right = "" },
			section_separators = { left = "", right = "" },
		},
		sections = {
			lualine_a = { "mode" },
			lualine_b = { "branch", "diff", "diagnostics" },
			lualine_c = {
				{ "filename", path = 1 },
				{
					function()
						local navic = require("nvim-navic")
						if navic.is_available() then
							return navic.get_location()
						end
						return ""
					end,
					cond = function()
						local navic = require("nvim-navic")
						return navic.is_available()
					end,
				},
			},
			lualine_x = { "encoding", "fileformat", "filetype" },
			lualine_y = { "progress" },
			lualine_z = { "location" },
		},
	},
}
