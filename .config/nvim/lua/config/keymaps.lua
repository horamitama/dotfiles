-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
local keymaps = vim.keymap

keymaps.set("n", "<leader>ne", "<cmd>:Neotree focus<CR>")
keymaps.set("n", "<leader>d", ":bdelete<CR>")
