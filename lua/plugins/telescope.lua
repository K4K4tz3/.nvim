return {
	'nvim-telescope/telescope.nvim',
	tag = '0.1.5',
	dependencies = { 'nvim-lua/plenary.nvim' },

	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local builtin = require("telescope.builtin")

		telescope.setup()

		--
		-- Find files in root dir
		--
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
		end, { desc = "Find Files: Root Directory" })


		--
		-- Find files in buffer list
		--
		vim.keymap.set("n", "<leader>fb", function()
			builtin.buffers({
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
		end, { desc = "Find Files: Buffer List" })




		--
		-- Find string in root files
		--
		vim.keymap.set("n", "<leader>sr", function()
			builtin.live_grep()
		end, { desc = "Search Root: Find string inside root files" })


		--
		-- Find string in current buffer
		--
		vim.keymap.set("n", "<leader>sb", function()
			builtin.current_buffer_fuzzy_find()
		end, { desc = "Search Buffer: Find string inside current buffer" })


		--
		-- Find string in current buffer
		--
		vim.keymap.set("n", "<leader>sa", function()
			builtin.live_grep({
				grep_open_files = true,
			})
		end, { desc = "Search Active: Find string in active buffers" })
	end,
}
