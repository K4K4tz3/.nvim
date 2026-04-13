vim.cmd("highlight Normal guibg=NONE ctermbg=NONE")
vim.cmd("highlight NormalNC guibg=NONE ctermbg=NONE")
vim.cmd("highlight EndOfBuffer guibg=NONE")

-- basic settings
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = false


vim.pack.add{
	{ src = "https://github.com/neovim/nvim-lspconfig" },
}
vim.pack.add{
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
}
vim.pack.add{
	{ src = "https://github.com/BurntSushi/ripgrep" },
}



require("config.keymaps")
require("config.lazy")

vim.api.nvim_create_autocmd("FileType", {
	pattern = { 'python' },
	callback = function() vim.treesitter.start() end,
})
