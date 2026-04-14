vim.g.mapleader = " "

--
-- Buffer Window Resize Keybinds
--
vim.keymap.set("n", "<C-h>", ":resize -5<CR>", { desc = "Decrease buffer width", silent = true })
vim.keymap.set("n", "<C-j>", ":vertical resize +5<CR>", { desc = "Increase buffer width", silent = true })
vim.keymap.set("n", "<C-k>", ":vertical resize -5<CR>", { desc = "Decrease buffer height", silent = true })
vim.keymap.set("n", "<C-l>", ":resize +5<CR>", { desc = "Increase buffer height", silent = true })
