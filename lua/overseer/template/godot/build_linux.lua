return {
  name = "Build Scons for linux",
  builder = function()
    return {
      cmd = { "scons", "platform=linux" },

      components = {
        {
          "on_output_quickfix",
          open = true,
        },
        "default",
      },
    }
  end,
}
