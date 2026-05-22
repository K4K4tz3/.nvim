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
						},
					},
				},
			})
		end,
  }
}
