return {
	"nvim-treesitter/nvim-treesitter",
	branch = "master",
	build = ":TSUpdate",
	lazy = false,

	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = { "lua", "vim", "vimdoc", "python", "cpp", "c",
													"html", "css", "javascript", "toml", "rust" },
			highlight = { enable = true },
			indent = { enable = true },
		})
	end,
}
