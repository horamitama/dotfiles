-- Terraform Language Server configuration
return {
	cmd = { "terraform-ls", "serve" },
	filetypes = { "terraform", "tf", "terraform-vars" },
	root_markers = { ".terraform", ".git" },
	settings = {
		terraformls = {
			experimentalFeatures = {
				validateOnSave = true,
				prefillRequiredFields = true,
			},
		},
	},
}
