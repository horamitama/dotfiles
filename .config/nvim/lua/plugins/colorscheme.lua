return {
  "gbprod/nord.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd.colorscheme("nord")
    require("nord").setup({
      transparent = true,
    })
  end,
}
