return {
  name = "SCons build",
  desc = "Build the current Godot GDExtension project for Linux",

  builder = function()
    return {
      cmd = { "scons", "compiledb=yes", "platform=linux" },
      cwd = vim.fn.getcwd(),

      components = {
        "default",
        "user.build_sound",
        "test.test_godot"
      },
    }
  end,
}
