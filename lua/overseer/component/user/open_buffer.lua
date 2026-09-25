return {
  desc = "Opens the Overseer buffer",

  constructor = function()
    return {
      on_start = function(self, task, status)
        require("panel").create_overseer()
      end,
    }
  end,
}
