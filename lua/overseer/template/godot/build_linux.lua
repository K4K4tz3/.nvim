return {
  name = "SCons build",
  desc = "Build the current Godot GDExtension project for Linux",

  builder = function()
    return {
      cmd = { "scons", "platform=linux" },
      cwd = vim.fn.getcwd(),

      components = {
        "default",
      },
    }
  end,
}
