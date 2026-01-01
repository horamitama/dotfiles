return {
	"sindrets/diffview.nvim",
	cmd = { "DiffviewOpen", "DiffviewFileHistory" },
	keys = {
		{ "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diff View" },
		{ "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File History" },
		{ "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Branch History" },
		{ "<leader>gc", "<cmd>DiffviewClose<cr>", desc = "Close Diff View" },
	},
	opts = {
		enhanced_diff_hl = true,
		view = {
			default = {
				layout = "diff2_horizontal",
			},
			merge_tool = {
				layout = "diff3_mixed",
			},
			file_history = {
				layout = "diff2_horizontal",
			},
		},
		file_panel = {
			win_config = {
				position = "left",
				width = 35,
			},
		},
		keymaps = {
			view = {
				["q"] = "<cmd>DiffviewClose<cr>",
			},
			file_panel = {
				["q"] = "<cmd>DiffviewClose<cr>",
				["j"] = "next_entry",
				["k"] = "prev_entry",
				["<cr>"] = "select_entry",
				["s"] = "stage_all",
				["S"] = "unstage_all",
				["R"] = "refresh_files",
			},
		},
	},
}
