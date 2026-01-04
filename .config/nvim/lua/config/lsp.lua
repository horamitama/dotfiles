-- LSP keymaps
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local bufnr = args.buf
		local map = function(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
		end
		map("n", "gd", vim.lsp.buf.definition, "Go to Definition")
		map("n", "gr", vim.lsp.buf.references, "References")
		map("n", "K", vim.lsp.buf.hover, "Hover")
		map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
		map("n", "<leader>cr", vim.lsp.buf.rename, "Rename")
		map("n", "<leader>cd", vim.diagnostic.open_float, "Line Diagnostics")
		map("n", "]d", vim.diagnostic.goto_next, "Next Diagnostic")
		map("n", "[d", vim.diagnostic.goto_prev, "Prev Diagnostic")
	end,
})

-- Lua
vim.lsp.config.lua_ls = {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			workspace = {
				checkThirdParty = false,
				library = vim.api.nvim_get_runtime_file("", true),
			},
			diagnostics = { globals = { "vim" } },
			telemetry = { enable = false },
		},
	},
}

-- TypeScript
vim.lsp.config.ts_ls = {
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
}

-- Enable LSP servers
vim.lsp.enable({ "lua_ls", "ts_ls" })
