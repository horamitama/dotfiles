local map = vim.keymap.set

-- Save and quit
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save File" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })

-- Move lines with Alt+j/k
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move Down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move Up" })

-- Clear search highlight
map("n", "<Esc><Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear hlsearch" })

-- Paste without overwriting register
map("x", "p", [["_dP]])

-- Line navigation with H/L
map("n", "H", "^", { desc = "Go to Start of Line" })
map("n", "L", "$", { desc = "Go to End of Line" })

-- Terminal (vertical right)
map("n", "<leader>tv", function()
  Snacks.terminal(nil, { win = { position = "right" } })
end, { desc = "Terminal (Vertical/Right)" })
