return {
  name = "Run C++ Unit Test - Doctest",
  desc = "After a successful linux build, all godot bound tests will be run.",

  builder = function()
    return {
      cmd = {
        "bin/tests --success --duration"},
      cwd = vim.fn.getcwd(),

      components = {
        {
          "dependencies",
          tasks = {
            "SCons Build for Linux",
          },
          sequential = true,
        },
        "default",
      },
    }
  end,
}
