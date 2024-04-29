local status, mason = pcall(require, "mason")
if(not status) then return end

local lspconfig = pcall(require, "mason-lspconfig") 
if(not lspconfig) then return end

mason.setup()

-- lspconfig.setup({
--   ensure_installed = {"sumneko_lua", "tailwindcss"},
-- })
