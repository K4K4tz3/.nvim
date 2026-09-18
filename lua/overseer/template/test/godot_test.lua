return {
  name = "Run C++ Godot Bound Unit Test - Doctest",
  desc = "After a successful linux build, all godot bound tests will be run.",

  builder = function()
    return {
      cmd = {
        vim.fn.expand("~/Downloads/Godot_v4.7.2-stable_linux.x86_64"),
        "--headless",
        "--path",
        "project",
        "res://tests/test_runner.tscn",
      },
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
