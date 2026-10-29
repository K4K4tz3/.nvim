local Panel = {
  win = nil,
  neotree = nil,

  windows = {
    main = nil,
    neotree = nil,

    bottom = {
      left = nil,
      right = nil,
    }
  },
  buffer = {
    main = nil,
    neotree = nil,

    bottom = {
      left = nil,
      right = nil,
    }
  }
}

function Panel.init()
  Panel.windows.neotree = vim.api.nvim_get_current_win()
  if Panel.windows.neotree == nil then
    return
  end

  require("neo-tree.command").execute({
    action = "focus",
    source = "filesystem",
    position = "current",
  })


  vim.api.nvim_create_user_command(
    "PanelOpenOverseer",
    function()
      Panel.open_overseer()
    end,
    { desc = "Opens overseers console and output buffer"}
  )

  vim.api.nvim_create_user_command(
    "PanelCloseOverseer",
    function()
      Panel.close_overseer()
    end,
    { desc = "Closes overseers console and output buffer"}
  )

  vim.api.nvim_create_user_command(
    "PanelPrintData",
    function()
      Panel.print_data()
    end,
    { desc = "Prints the window/buffer data"}
  )

end

function Panel.open_main()
  if Panel.windows.main and vim.api.nvim_win_is_valid(Panel.windows.main) then
    return
  end

  local main = vim.api.nvim_open_win(0, true, {
    win = Panel.windows.neotree,
    split = "right"
  })

  if main then
    Panel.windows.main = main
  end
end

function Panel.create_neotree()
  Panel.neotree = vim.api.nvim_open_win(0, true, {
    split = "left",
    win = -1,
    width = 30,
  })

  require("neo-tree.command").execute({
    action = "focus",
    source = "filesystem",
    position = "current",
  })

  vim.api.nvim_set_current_win(Panel.win)
end

function Panel.open_overseer()
  -- check if overseer is already opened
  if Panel.check_winbuf_condition(Panel.windows.bottom.left, Panel.buffer.bottom.left, "OverseerList")
    and Panel.check_winbuf_condition(Panel.windows.bottom.right, Panel.buffer.bottom.right, "OverseerOutput") then
    return
  end

  require("overseer").close()
  Panel.clear_bottom()

  vim.notify("Open Overseer")

  require("overseer").open({
    enter = true
  })

  local window = vim.api.nvim_get_current_win()

  if window then
    local buffer = vim.api.nvim_win_get_buf(window)

    if Panel.check_winbuf_condition(window, buffer, "OverseerList") then
      -- If window and buffer correspond to OverseerList store their values
      Panel.windows.bottom.left = window
      Panel.buffer.bottom.left = buffer
    else
      vim.notify(
        "Failed to retrieve window or buffer of OverseerList",
        {
          "Panel::open_overseer"
        }
      )
    end
  end

  vim.cmd("wincmd l") -- move focus to overseer_output window

  window = vim.api.nvim_get_current_win()
  if window then
    local buffer = vim.api.nvim_win_get_buf(window)

    if Panel.check_winbuf_condition(window, buffer, "OverseerOutput") then
      -- If window and buffer correspond to OverseerList store their values
      Panel.windows.bottom.right = window
      Panel.buffer.bottom.right = buffer
    else
      vim.notify(
        "Failed to retrieve window or buffer of OverseerOutput",
        {
          "Panel::open_overseer"
        }
      )
    end
  end
end

function Panel.close_overseer()
  if Panel.windows.bottom.left != nil and vim.api.nvim_win_is_valid(Panel.windows.bottom.left) then
    vim.api.nvim_win_close(Panel.windows.bottom.left, true)
    Panel.windows.bottom.left = nil
  end

  if Panel.windows.bottom.right != nil and vim.api.nvim_win_is_valid(Panel.windows.bottom.right) then
    vim.api.nvim_win_close(Panel.windows.bottom.right, true)
    Panel.windows.bottom.right = nil
  end
end

function Panel.apply_layout()
  vim.api.nvim_win_set_width(Panel.windows.neotree, 30)
end

--
-- Clear/Hide
--

function Panel.hide_overseer()
  vim.api.nvim_win_hide(Panel.overseer)
  Panel.overseer = nil
end

function Panel.clear_bottom()
  Panel.windows.bottom.left = nil
  Panel.buffer.bottom.left = nil
  Panel.windows.bottom.right = nil
  Panel.buffer.bottom.right = nil
end

--
-- Helper
--

function Panel.set_buf(file)
  local buf = vim.fn.bufadd(file)
  vim.api.nvim_win_set_buf(Panel.win, buf)
end

function Panel.set_buf_and_open(file)
  local buf = vim.fn.bufadd(file)

  if not Panel.win then
    vim.api.nvim_open_win(buf, true, {
      win = Panel.windows.neotree,
      split = "right"
    })
  else
    vim.api.nvim_win_set_buf(Panel.win, buf)
    vim.api.nvim_set_current_win(Panel.win)
  end
end

function Panel.test_dap()
  require("dapui").open()

  vim.schedule(function()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      print(
        "buf: ", buf,
        "name: ", vim.api.nvim_buf_get_name(buf),
        "filetype: ", vim.bo[buf].filetype,
        "buftype: ", vim.bo[buf].buftype
      )
    end
  end)
end

function Panel.get_panel()
  return Panel
end

function Panel.get_buf_by_filetype(filetype)
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].filetype == filetype then
      return buf
    end
  end
  vim.notify(
    "Failed to find type: " .. filetype,
    {
      "Panel::get_buf_by_filetype"
    }
  )
end

function Panel.get_win_from_buf(bufnr)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(win) == bufnr then
      return win
    end
  end
  return nil
end

-- Validator to check window and buffer state to be valid and of certain type
function Panel.check_winbuf_condition(window, buffer, type)
  if window and vim.api.nvim_win_is_valid(window) then
    if buffer and vim.api.nvim_buf_is_valid(buffer) then
      if vim.bo[buffer].filetype == type then
        return true
      end
    end
  end
end

function Panel.print_data()
  vim.notify(
    "Windows: " ..
    "\nLeft: " .. tostring(Panel.windows.bottom.left) ..
    "\nRight: " .. tostring(Panel.windows.bottom.right) ..
    "\nBuffer: " ..
    "\nLeft: " .. tostring(Panel.buffer.bottom.left) ..
    "\nRight: " .. tostring(Panel.buffer.bottom.right),
    vim.log.levels.INFO,
    {
      title = "Panel::print_data"
    }
  )
end

return Panel
