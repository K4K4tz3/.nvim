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
				cmd = {
					"clangd",
					"--background-index",
					"--clang-tidy",
					"--header-insertion=never",
				},
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

			vim.lsp.config("rust_analyzer", {
				cmd = { "rust-analyzer" },
				filetypes = { "rust" },

				root_dir = function(bufnr, on_dir)
					local root = vim.fs.root(bufnr, {
						"Cargo.toml",
						"rust-project.json",
						".git",
					})

					if root then
						on_dir(root)
						return
					end

					local filename = vim.api.nvim_buf_get_name(bufnr)
					on_dir(vim.fs.dirname(filename))
				end,

				before_init = function(params, config) 
					local filename = vim.api.nvim_buf_get_name(0)

					local cargo_root = vim.fs.root(filename, {
						"Cargo.toml",
						"rust-project.json",
					})

					-- Only use standalone mode when this is not a normal project
					if not cargo_root then
						config.settings = config.settings or {}
						config.settings["rust-analyzer"] =
							config.settings["rust-analyzer"] or {}

						config.settings["rust-analyzer"].linkedProjects = {
							filename,
						}
					end
				end,
			})

      vim.lsp.enable("clangd")
      vim.lsp.enable("pyright")
			vim.lsp.enable("html")
			vim.lsp.enable("emmet_language_server")
			vim.lsp.enable("rust")
			vim.lsp.enable("rust_analyzer")
    end,
  },
}
