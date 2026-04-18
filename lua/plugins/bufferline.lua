return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		local bufferline = require("bufferline")

		bufferline.setup({
			options = {
				mode = "tabs",
				style_preset = bufferline.style_preset.default,
				offsets = {
					{
						filetype = "neo-tree"
					}
				}
			}
		})
	end,
}
