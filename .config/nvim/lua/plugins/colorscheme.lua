return {
	"gbprod/nord.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("nord").setup({
			transparent = true,
			borders = true,
			styles = {
				comments = { italic = true },
			},
		})
		vim.cmd.colorscheme("nord")
		vim.api.nvim_set_hl(0, "LineNr", { fg = "#4c566a" })
		vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#88c0d0", bold = true })
	end,
}
