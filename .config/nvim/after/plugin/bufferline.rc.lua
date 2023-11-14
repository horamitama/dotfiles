local status, highlights = pcall(require, "bufferline")
if(not status) then return end

highlights = require("nord").bufferline.highlights({
    italic = true,
    bold = true,
    fill = "#181c24"
})

require("bufferline").setup({
    options = {
        separator_style = "slant",
    },
    highlights = highlights,
})

vim.keymap.set('n', '<Tab>', '<Cmd>BufferLineCycleNext<CR>', {})
vim.keymap.set('n', '<S-Tab>', '<Cmd>BufferLineCyclePrev<CR>', {})
