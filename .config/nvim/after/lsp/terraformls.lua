---@type vim.lsp.Config
return {
	-- stderr の冗長ログが lsp.log に [ERROR] として溜まるのを防ぐ
	cmd = { "terraform-ls", "serve", "-log-file=/dev/null" },
	-- environments/* ごとに別プロセスが立たないようリポジトリ単位に統一
	root_markers = { ".git" },
	init_options = {
		indexing = {
			ignoreDirectoryNames = { "node_modules" },
		},
	},
	on_attach = function(client, bufnr)
		-- semantic tokens と treesitter の競合でハイライトが崩れるため treesitter に任せる
		client.server_capabilities.semanticTokensProvider = nil
		vim.lsp.codelens.enable(true, { bufnr = bufnr })
	end,
}
