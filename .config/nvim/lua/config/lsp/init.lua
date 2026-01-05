-- Load LSP keymaps
require("config.lsp.keymaps")

-- Define LSP servers to enable
local servers = {
	lua_ls = require("config.lsp.servers.lua_ls"),
	ts_ls = require("config.lsp.servers.ts_ls"),
}

-- Configure each LSP server
for server_name, config in pairs(servers) do
	vim.lsp.config[server_name] = config
end

-- Enable LSP servers
vim.lsp.enable(vim.tbl_keys(servers))
