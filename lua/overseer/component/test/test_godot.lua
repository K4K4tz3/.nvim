return {
  desc = "Test Godot Bound tests",

  constructor = function(params)
    return {
      on_complete = function(self, task, status)
        local overseer = require("overseer")

        if status == overseer.STATUS.SUCCESS then
          overseer.run_task({
            name = "Godot tests",
          })
        end
      end,
    }
  end,
}
