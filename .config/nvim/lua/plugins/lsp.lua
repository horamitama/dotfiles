return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		build = ":MasonUpdate",
		opts = {},
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		dependencies = { "mason.nvim" },
		opts = {
			ensure_installed = {
				"lua_ls",
				"ts_ls",
				"jdtls",
				"yamlls",
				"gopls",
				"terraformls",
				"pyright",
			},
			automatic_installation = true,
		},
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		dependencies = {
			"mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- Python
			vim.lsp.config.pyright = {
				cmd = { "pyright-langserver", "--stdio" },
				filetypes = { "python" },
				root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile" },
				capabilities = capabilities,
				settings = {
					python = {
						analysis = {
							autoSearchPaths = true,
							useLibraryCodeForTypes = true,
							diagnosticMode = "workspace",
						},
					},
				},
			}

			-- Lua
			vim.lsp.config.lua_ls = {
				cmd = { "lua-language-server" },
				filetypes = { "lua" },
				root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml" },
				capabilities = capabilities,
			}

			-- TypeScript/JavaScript
			vim.lsp.config.ts_ls = {
				cmd = { "typescript-language-server", "--stdio" },
				filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
				root_markers = { "package.json", "tsconfig.json", "jsconfig.json" },
				capabilities = capabilities,
			}

			-- Go
			vim.lsp.config.gopls = {
				cmd = { "gopls" },
				filetypes = { "go", "gomod", "gowork", "gotmpl" },
				root_markers = { "go.mod", "go.work" },
				capabilities = capabilities,
			}

			-- YAML
			vim.lsp.config.yamlls = {
				cmd = { "yaml-language-server", "--stdio" },
				filetypes = { "yaml", "yaml.docker-compose" },
				root_markers = { ".git" },
				capabilities = capabilities,
			}

			-- Java
			vim.lsp.config.jdtls = {
				cmd = { "jdtls" },
				filetypes = { "java" },
				root_markers = { "pom.xml", "build.gradle", ".git" },
				capabilities = capabilities,
			}

			-- Terraform
			vim.lsp.config.terraformls = {
				cmd = { "terraform-ls", "serve" },
				filetypes = { "terraform", "tf" },
				root_markers = { ".terraform", ".git" },
				capabilities = capabilities,
			}

			-- Enable LSP for configured servers
			vim.lsp.enable({ "pyright", "lua_ls", "ts_ls", "gopls", "yamlls", "jdtls", "terraformls" })
		end,
	},
	{ "gkz/vim-ls", lazy = false },
}
