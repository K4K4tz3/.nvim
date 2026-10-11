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
							["<cr>"] = "open_with_window_picker",
							["H"] = "none",
						},
					},
				},
			})
      require("window-picker").setup({
        filter_func = function()
          local panel = require("panel")
          local allowed = {}

          panel.open_main()

          local window_ids = vim.api.nvim_list_wins()

          for _, winid in ipairs(window_ids) do
            if winid == panel.windows.main then
              table.insert(allowed, winid)
            end
          end

          return allowed
        end,
      })
		end,
  }
}
