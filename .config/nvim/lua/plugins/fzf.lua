return {
	"ibhagwan/fzf-lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	cmd = "FzfLua",
	keys = {
		{ "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find Files" },
		{ "<leader>fr", "<cmd>FzfLua oldfiles<cr>", desc = "Recent Files" },
		{ "<leader>fg", "<cmd>FzfLua live_grep<cr>", desc = "Live Grep" },
		{ "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "Buffers" },
		{ "<leader>fh", "<cmd>FzfLua help_tags<cr>", desc = "Help Tags" },
		{ "<leader>/", "<cmd>FzfLua grep_curbuf<cr>", desc = "Search in Buffer" },
	},
	opts = {
		winopts = {
			height = 0.85,
			width = 0.80,
			row = 0.35,
			col = 0.50,
			border = "rounded",
			preview = {
				layout = "flex",
				flip_columns = 120,
			},
		},
		fzf_opts = {
			["--layout"] = "reverse",
		},
		files = {
			prompt = "Files❯ ",
			cwd_prompt = false,
		},
		grep = {
			prompt = "Grep❯ ",
		},
	},
}
