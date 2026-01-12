local map = vim.keymap.set

-- Save and quit
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save File" })
map("n", "<leader>q", "<cmd>wqa<cr>", { desc = "Quit" })

-- Move lines with Alt+j/k
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move Down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move Up" })

-- Clear search highlight
map("n", "<Esc><Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear hlsearch" })

-- Paste without overwriting register
map("x", "p", [["_dP]])

-- Window navigation with Ctrl+h/j/k/l
map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window" })

-- Lazy
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- LSP keymaps
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local bufnr = args.buf
		local cmap = function(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
		end
		cmap("n", "gd", vim.lsp.buf.definition, "Go to Definition")
		cmap("n", "gr", vim.lsp.buf.references, "References")
		cmap("n", "K", vim.lsp.buf.hover, "Hover")
		cmap("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
		cmap("n", "<leader>cr", vim.lsp.buf.rename, "Rename")
		cmap("n", "<leader>cd", vim.diagnostic.open_float, "Line Diagnostics")
	end,
})
