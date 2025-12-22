-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Apply with <leader> (usually Space key)

local map = vim.keymap.set

-- ■ 1. 保存と終了を爆速にする
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save File" }) -- Space + w で保存
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" }) -- Space + q で終了

-- ■ 2. 行の移動を直感的に（Alt + j/k で行ごと上下移動）
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move Down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move Up" })

-- ■ 3. 検索ハイライトを消す（Esc 2回押し）
-- 検索後に画面が黄色くなっているのを消す操作
map("n", "<Esc><Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear hlsearch" })

-- ■ 4. ペースト時の「上書き問題」を解決
-- ビジュアルモードで貼り付けたとき、クリップボードの中身が「削除した文字」に置き換わらないようにする魔法の設定
map("x", "p", [["_dP]])

-- ■ 5. 行末・行頭への移動をH/Lで（Vim熟練度アップ）
-- デフォルトではHは画面上部、Lは画面下部ですが、行頭(^)と行末($)にした方がコーディングでは便利です
map("n", "H", "^", { desc = "Go to Start of Line" })
map("n", "L", "$", { desc = "Go to End of Line" })

-- <leader>tv でターミナルを右側に開く
map("n", "<leader>tv", function()
	Snacks.terminal(nil, { win = { position = "right" } })
end, { desc = "Terminal (Vertical/Right)" })

-- Ctrl + / でターミナルを「右側」に開く
-- map({ "n", "t" }, "<C-/>", function()
-- 	Snacks.terminal(nil, { win = { position = "right" } })
-- end, { desc = "Terminal (Vertical/Right)" })
