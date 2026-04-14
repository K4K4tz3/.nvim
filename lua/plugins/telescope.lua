return {
	'nvim-telescope/telescope.nvim',
	tag = '0.1.5',
	dependencies = { 'nvim-lua/plenary.nvim' },

	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local builtin = require("telescope.builtin")

		telescope.setup()

		vim.keymap.set("n", "<leader>ff", function()
			builtin.find_files({
				attach_mappings = function(_, map)
					-- Edit 
					map("i", "<CR>", function(prompt_bufnr)
						actions.select_default(prompt_bufnr)
					end)
					map("n", "<CR>", function(prompt_bufnr)
						actions.select_default(prompt_bufnr)
					end)
					-- VSP 
					map("i", ":v<CR>", function(prompt_bufnr)
						actions.select_vertical(prompt_bufnr)
					end)
					map("n", ":v<CR>", function(prompt_bufnr)
						actions.select_vertical(prompt_bufnr)
					end)
					return true
				end,
			})
		end, { desc = "Find files (vsp)" })
	end,
}
