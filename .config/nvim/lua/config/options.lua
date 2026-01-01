vim.env.PATH = vim.env.PATH .. ":/usr/local/go/bin"

local opt = vim.opt

-- Indent
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.smartindent = true

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Hide ~ on empty lines
opt.fillchars = { eob = " " }

-- Use system clipboard
opt.clipboard = "unnamedplus"

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
	end,
})

-- Cursor line highlight
opt.cursorline = true
