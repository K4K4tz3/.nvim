return {
	"folke/noice.nvim",
	event = "VeryLazy",
	opts = {

	},
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},
	config = function()
		require("noice").setup({
			views = {
				cmdline_popup = {
					position = {
						row = "45%",
						col = "50%",
					},
					size = {
						width = 60,
						height = "auto",
					},
				},
				popupmenu = {
					position = {
						row = "60%",
						col = "50%",
					},
					size = {
						width = 60,
						height = 10,
					},
					border = {
						style = "rounded",
						padding = { 0, 1 },
					},
					win_options = {
						winhighlight = { Normal = "Normal", FloatBoarder = "DiagnosticInfo" },
					},
				},
			},
		})
	end,
}
