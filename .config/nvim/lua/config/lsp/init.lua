-- Load LSP keymaps
require("config.lsp.keymaps")

-- Get capabilities from cmp_nvim_lsp
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Define LSP servers to enable
local servers = {
	lua_ls = require("config.lsp.servers.lua_ls"),
	vtsls = require("config.lsp.servers.vtsls"),
	jdtls = require("config.lsp.servers.jdtls"),
	yamlls = require("config.lsp.servers.yamlls"),
	gopls = require("config.lsp.servers.gopls"),
	terraformls = require("config.lsp.servers.terraformls"),
	pyright = require("config.lsp.servers.pyright"),
}

-- Configure each LSP server
for server_name, config in pairs(servers) do
	-- Add capabilities to each server config
	config.capabilities = capabilities
	vim.lsp.config[server_name] = config
end

-- Enable LSP servers
vim.lsp.enable(vim.tbl_keys(servers))
