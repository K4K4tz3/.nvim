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

			vim.lsp.config("tailwindcss_language_server", {
				capabilities = capabilities,
				filetypes = { "html", },
			})

			vim.lsp.enable({
				"clangd", "pyright", "html", "emmet_language_server", "tailwindcss_language_server"
			})
    end,
  },
}
