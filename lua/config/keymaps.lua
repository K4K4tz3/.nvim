vim.g.mapleader = " "
--
-- Window Resize Keybinds
--
vim.keymap.set("n", "<S-h>", ":vertical resize -5<CR>", { desc = "Decrease buffer width", silent = true })
vim.keymap.set("n", "<S-j>", ":resize +5<CR>", { desc = "Increase buffer height", silent = true })
vim.keymap.set("n", "<S-k>", ":resize -5<CR>", { desc = "Decrease buffer height", silent = true })
vim.keymap.set("n", "<S-l>", ":vertical resize +5<CR>", { desc = "Increase buffer width", silent = true })

--
-- Window Self - Movement
--
vim.keymap.set("n", "<C-h>", "<C-W>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-W>j", { desc = "Move to bottom window" })
vim.keymap.set("n", "<C-k>", "<C-W>k", { desc = "Move to top window" })
vim.keymap.set("n", "<C-l>", "<C-W>l", { desc = "Move to right window" })
