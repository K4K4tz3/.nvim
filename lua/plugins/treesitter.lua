return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  lazy = false,

  config = function()
    local ts = require("nvim-treesitter")

    ts.setup({})
    ts.install({
      "lua", "vim", "vimdoc", "python", "cpp", "c",
      "html", "css", "javascript", "toml", "rust",
    })

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("TreesitterHighlight", {
        clear = true,
      }),
      pattern = {
        "lua", "vim", "help", "python", "cpp", "c",
        "html", "css", "javascript", "toml", "rust",
      },
      callback = function(event)
        vim.treesitter.start(event.buf)
      end,
    })
  end,
}
