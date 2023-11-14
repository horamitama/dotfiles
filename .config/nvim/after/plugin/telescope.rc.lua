local status, telescope = pcall(require, "telescope")
if(not status) then return end

local fb_actions = telescope.extensions.file_browser.actions

require("telescope").setup {
  defaults = {
    mappings = {},
  },
  pickers = {},
  extensions = {
    file_browser = {
      theme = "dropdown",
      hijack_netrw = true,
      mappings = {
      --   ["i"] = {
      --   },
        ["n"] = {
          ["a"] = fb_actions.create,
          ["r"] = fb_actions.rename,
        },
      },
      grouped = true,
      initial_mode = "normal",
      layout_config = { height = 40 },
      respect_gitignore = false,
      hidden = true,
      previewer = false,
    },
  },
}
require("telescope").load_extension "file_browser"

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

vim.keymap.set('n', '<leader>fs', require "telescope".extensions.file_browser.file_browser, {})
