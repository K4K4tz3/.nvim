return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	branch = "master",
	build = ":TSUpdate",

	config = function()
		local treesitter = require("nvim-treesitter")

		treesitter.setup()
		treesitter.install( {
			"python"
		})
	end,
}
