vim.g.mapleader = " "

local keymap = vim.keymap
-- Split window
keymap.set('n', 'ss', ':split<Return><C-w>w')
keymap.set('n', 'sv', ':vsplit<Return><C-w>w')
keymap.set('', 'sh', '<C-w>h')
keymap.set('', 'sk', '<C-w>k')
keymap.set('', 'sj', '<C-w>j')
keymap.set('', 'sl', '<C-w>l')

keymap.set('n', 'bd', ':bdelete<CR>')

keymap.set('n', '<leader>gm', ':GitMessenger')

keymap.set('n', '<C-l>', '<Cmd>echom b:_copilot<CR>')
