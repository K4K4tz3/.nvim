return {
  name = "run script",
  builder = function()
    return {
      cmd = { "echo", "hello worl" },

      components = {
        "default",
      },
    }
  end,
}
