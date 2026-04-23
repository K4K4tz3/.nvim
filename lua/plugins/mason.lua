return {
	"mason-org/mason.nvim",
	opts = {},
	
	config = function()
		mason = require("mason")

		mason.setup()
	end,
}
