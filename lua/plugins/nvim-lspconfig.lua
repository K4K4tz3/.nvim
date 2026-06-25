return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      vim.lsp.config("clangd", {
        capabilities = capabilities,
      })

      vim.lsp.config("pyright", {
        capabilities = capabilities,
      })

			vim.lsp.config("html", {
        capabilities = capabilities,
        filetypes = { "html" },
      })

      vim.lsp.config("emmet_language_server", {
        capabilities = capabilities,
        filetypes = {
          "html",
          "css",
          "javascriptreact",
          "typescriptreact",
        },
      })

			vim.lsp.config("rust", {
				capabilities = capabilities,
				filetypes = {
					"toml",
					"rust"
				},
			})

      vim.lsp.enable("clangd")
      vim.lsp.enable("pyright")
			vim.lsp.enable("html")
			vim.lsp.enable("emmet_language_server")
			vim.lsp.enable("rust")
    end,
  },
}
