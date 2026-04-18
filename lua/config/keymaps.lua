vim.g.mapleader = " "
--
-- Buffer Window Resize Keybinds
--
vim.keymap.set("n", "<C-h>", ":vertical resize -5<CR>", { desc = "Decrease buffer width", silent = true })
vim.keymap.set("n", "<C-j>", ":resize +5<CR>", { desc = "Increase buffer height", silent = true })
vim.keymap.set("n", "<C-k>", ":resize -5<CR>", { desc = "Decrease buffer height", silent = true })
vim.keymap.set("n", "<C-l>", ":vertical resize +5<CR>", { desc = "Increase buffer width", silent = true })
