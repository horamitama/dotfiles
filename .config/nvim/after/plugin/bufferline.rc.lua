local status, highlights = pcall(require, "bufferline")
if(not status) then return end

require("bufferline").setup({
    options = {
        separator_style = "thin",
    },
    highlights = require("nord.plugins.bufferline").akinsho(),
})

vim.keymap.set('n', '<Tab>', '<Cmd>BufferLineCycleNext<CR>', {})
vim.keymap.set('n', '<S-Tab>', '<Cmd>BufferLineCyclePrev<CR>', {})
