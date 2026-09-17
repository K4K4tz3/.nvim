return {
  name = "Godot tests",

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
    }
  end,
}
