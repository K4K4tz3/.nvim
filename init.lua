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

vim.lsp.enable("pyright")


require("config.keymaps")
require("config.lazy")

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client and client:supports_method("textDocument/completion") then
			vim.opt.completeopt = { "menuone", "noselect", "popup" }
			vim.lsp.completion.enable(true, client.id, ev.buf, {
				autotrigger = true,
			})
		end
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { 'python' },
	callback = function() vim.treesitter.start() end,
})

vim.keymap.set("i", "<C-Space>", function()
	vim.lsp.completion.get()
end)
