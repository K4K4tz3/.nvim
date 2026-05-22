return {
	"s1n7ax/nvim-window-picker",
	version = "v2.5.0",

	config = function()
		require("window-picker").setup({
			filter_rules = {
				include_current_win = false,
				autoselect_one = true,
				bo = {
					filetype = {
						"neo-tree",
						"neo-tree-popup",
						"notify",
					},
					buftype = {
						"terminal",
						"quickfix",
					},
				},
			},
		})
	end,
}
