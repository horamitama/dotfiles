-- Load LSP keymaps
require("config.lsp.keymaps")

-- Define LSP servers to enable
local servers = {
	lua_ls = require("config.lsp.servers.lua_ls"),
	ts_ls = require("config.lsp.servers.ts_ls"),
	jdtls = require("config.lsp.servers.jdtls"),
	yamlls = require("config.lsp.servers.yamlls"),
	gopls = require("config.lsp.servers.gopls"),
	terraformls = require("config.lsp.servers.terraformls"),
}

-- Configure each LSP server
for server_name, config in pairs(servers) do
	vim.lsp.config[server_name] = config
end

-- Enable LSP servers
vim.lsp.enable(vim.tbl_keys(servers))
