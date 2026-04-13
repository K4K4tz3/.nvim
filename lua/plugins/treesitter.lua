return {
	"nvim-treesitter/nvim-treesitter",
	branch = "master",
	build = ":TSUpdate",
	lazy = false,

	config = function()
		local parser_install_dir = vim.fn.stdpath("data") .. "/site/parser"
		vim.opt.runtimepath:prepend(parser_install_dir)

		require("nvim-treesitter.configs").setup({
			parser_install_dir = parser_install_dir,
			ensure_installed = { "lua", "vim", "vimdoc", "python", "cpp", "c" },
			highlight = { enable = true },
			indent = { enable = true },
		})
	end,
}
