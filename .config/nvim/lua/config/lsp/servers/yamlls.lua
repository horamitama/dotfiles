-- YAML Language Server configuration
return {
	cmd = { "yaml-language-server", "--stdio" },
	filetypes = { "yaml", "yaml.docker-compose", "yml" },
	root_markers = { ".git" },
	settings = {
		yaml = {
			schemaStore = {
				enable = true,
				url = "https://www.schemastore.org/api/json/catalog.json",
			},
			schemas = {
				-- Specific file patterns for schemas
				["https://json.schemastore.org/kustomization.json"] = "kustomization.{yml,yaml}",
				["https://json.schemastore.org/github-workflow.json"] = ".github/workflows/*",
				["https://json.schemastore.org/github-action.json"] = ".github/action.{yml,yaml}",
				["https://json.schemastore.org/prettierrc.json"] = ".prettierrc.{yml,yaml}",
				["https://json.schemastore.org/chart.json"] = "Chart.{yml,yaml}",
				["https://json.schemastore.org/circleciconfig.json"] = ".circleci/**/*.{yml,yaml}",
				["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "docker-compose*.{yml,yaml}",
				-- Kubernetes schema for specific directories only
				kubernetes = {
					"k8s/**/*.yaml",
					"kubernetes/**/*.yaml",
					"manifests/**/*.yaml",
				},
			},
			format = { enable = true },
			validate = true,
			completion = true,
			hover = true,
		},
	},
}
