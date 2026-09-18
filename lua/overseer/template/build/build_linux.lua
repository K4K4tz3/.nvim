return {
  name = "SCons Build for Linux",
  desc = "Build the current Godot GDExtension project for Linux",

  builder = function()
    return {
      cmd = {
        "scons",
        "compiledb=yes",
        "platform=linux",
        "debug_symbols=yes",
        "optimize=none"
      },
      cwd = vim.fn.getcwd(),

      components = {
        "default",
        "user.build_sound",
      },
    }
  end,
}
