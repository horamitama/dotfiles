return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "InsertEnter",
	enabled = false,
	opts = {
		suggestion = {
			enabled = true,
			auto_trigger = true,
			keymap = {
				accept = "<C-y>",
				accept_word = "<C-Right>",
				accept_line = "<C-Down>",
				next = "<M-]>",
				prev = "<M-[>",
				dismiss = "<C-]>",
			},
		},
		panel = {
			enabled = true,
			keymap = {
				open = "<M-CR>",
			},
		},
		filetypes = {
			markdown = true,
			help = false,
			gitcommit = true,
			gitrebase = false,
			["."] = false,
		},
	},
}
