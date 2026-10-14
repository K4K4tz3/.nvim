return {
  desc = "Send Task buffer to panel_manager to display the output",

  constructor = function()
    return {
      on_start = function(self, task, status)
        require("panel").open_overseer()
      end
    }
  end
}
