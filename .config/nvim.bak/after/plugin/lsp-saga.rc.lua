local status, lspsaga = pcall(require, "lspsaga")
if(not status) then return end 
local config = lspsaga.setup()

-- vim.keymap.set('n', '<C-j>', '<Cmd>Lspsaga diagnostic_jump_next<CR>', {})
vim.keymap.set('n', 'K', '<Cmd>Lspsaga hover_doc<CR>', {})
vim.keymap.set('n', '<leader>gf', '<Cmd>Lspsaga finder def+ref<CR>', {})
-- vim.keymap.set('i', '<C-k>', '<Cmd>Lspsaga signature_help<CR>', {})
vim.keymap.set('n', '<leader>gp', '<Cmd>Lspsaga peek_type_definition<CR>', {})
vim.keymap.set('n', '<leader>gr', '<Cmd>Lspsaga rename<CR>', {})
vim.keymap.set('n', '<leader>gd', '<Cmd>Lspsaga goto_definition<CR>', {})
vim.keymap.set('n', '<leader>gt', '<Cmd>Lspsaga term_toggle<CR>', {})

