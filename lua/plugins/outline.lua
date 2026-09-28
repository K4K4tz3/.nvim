return {
  "hedyhli/outline.nvim",
  cmd = { "Outline", "OutlineOpen" },

  config = function()
    require("outline").setup({})
  end
}
