return {
		'nvim-telescope/telescope.nvim',
		tag = '0.1.5',
		dependencies = { 'nvim-lua/plenary.nvim' },

		config = function()
				local telescope = require("telescope")
				local builtin = require("telescope.builtin")

				telescope.setup()

				vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
		end,
}
