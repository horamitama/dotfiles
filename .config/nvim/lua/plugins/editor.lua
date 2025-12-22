return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		opts = {
			filesystem = {
				filtered_items = {
					visible = false, -- when true, they will just be displayed differently than normal items
					hide_dotfiles = false,
					hide_gitignored = false,
					hide_hidden = false, -- only works on Windows for hidden files/directories
				},
			},
		},
		config = function(_, opts)
			local function on_move(data)
				LazyVim.lsp.on_rename(data.source, data.destination)
			end

			local events = require("neo-tree.events")
			opts.event_handlers = opts.event_handlers or {}
			vim.list_extend(opts.event_handlers, {
				{ event = events.FILE_MOVED, handler = on_move },
				{ event = events.FILE_RENAMED, handler = on_move },
			})
			require("neo-tree").setup(opts)
			vim.api.nvim_create_autocmd("TermClose", {
				pattern = "*lazygit",
				callback = function()
					if package.loaded["neo-tree.sources.git_status"] then
						require("neo-tree.sources.git_status").refresh()
					end
				end,
			})
		end,
	},
	-- lua/plugins/editor.lua または lua/plugins/gitsigns.lua
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			current_line_blame = true, -- これを true にすると常時有効になります（toggle不要なら）
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
				-- ▼ ここが一番重要です
				delay = 0, -- デフォルトは1000(1秒)。0〜100にすると爆速になります。
				ignore_whitespace = false,
			},
		},
	},
}
