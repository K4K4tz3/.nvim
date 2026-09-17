return {
  name = "Run tests",
  desc = "Run C++ unit tests",

  builder = function()
    return {
      cmd = "scons bin/tests debug_symbols=yes optimize=none && bin/tests --success --duration",
      cwd = vim.fn.getcwd(),

      components = {
        "default",
      },
    }
  end,
}
