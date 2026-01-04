return {
	{
		"akinsho/bufferline.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			options = {
				mode = "buffers",
				always_show_bufferline = true,
				show_buffer_close_icons = false,
				show_close_icon = false,
				separator_style = slant,
				diagnostics = "nvim_lsp",
				offsets = {
					{
						filetype = "neo-tree",
						text = "File Explorer",
						highlight = "Directory",
						separator = true,
					},
				},
			},
		},
		keys = {
			{ "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
			{ "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
			{ "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "Pin Buffer" },
			{ "<leader>bc", "<cmd>BufferLinePickClose<cr>", desc = "Pick Close Buffer" },
		},
	},
}
