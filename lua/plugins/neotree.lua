return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",

    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons", -- optional, but recommended
			"s1n7ax/nvim-window-picker",
    },

    lazy = false, -- neo-tree will lazily load itself

		config = function()
			require("neo-tree").setup({
				filesystem = {
					window = {
						mappings = {
							["w"] = "open_with_window_picker",
							["S"] = "split_with_window_picker",
							["s"] = "vsplit_with_window_picker",
							["<cr>"] = function(state)
                local node = state.tree:get_node()

                if not node then 
                  return
                end

                if node.type == "directory" then
                  state.commands["open"](state)
                end

                if node.type == "file" then
                  require("panel").set_buf_and_open(node.path)
                end
              end,
							["H"] = "none",
						},
					},
				},
			})
		end,
  }
}
