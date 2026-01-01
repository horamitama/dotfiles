return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		{
			"SmiteshP/nvim-navic",
			opts = {
				lsp = { auto_attach = true },
				highlight = true,
			},
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
