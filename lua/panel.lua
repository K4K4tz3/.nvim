local Panel = {
  win = nil,
  neotree = nil,
  overseer = nil,
  overseer_buf = nil,
  bottom_box_is_empty = true,
  win_bot_left = nil,
  win_bot_right = nil,
  cleanup_windows = {},

  windows = {
    main = nil,
    neotree = nil,

    bottom_left = nil,
    bottom_right = nil,

    right = nil,
  },

  contents = {
    bottom_left = nil,
    bottom_right = nil,
  }
}

function Panel.init()
  Panel.windows.main = vim.api.nvim_get_current_win()
  if Panel.windows.main == nil then
    return
  end

  Panel.open_neotree()
end

-- Cleans up windows that might not get closed before
function Panel.cleanup_wins()
  local it = 1

  while it <= #Panel.cleanup_windows do
    if vim.api.nvim_win_is_valid(Panel.cleanup_windows[it]) then
      vim.api.nvim_win_close(Panel.cleanup_windows[it], true)
    end
    table.remove(Panel.cleanup_windows, it)

    if Panel.cleanup_windows == nil then
      break
    end
  end
end

function Panel.open_neotree()
  Panel.windows.neotree = vim.api.nvim_open_win(0, true, {
    split = "left",
    win = -1,
    width = 30,
  })

  require("neo-tree.command").execute({
    action = "focus",
    source = "filesystem",
    position = "current",
  })

  vim.api.nvim_set_current_win(Panel.windows.main)
end

function Panel.open_bottom_box()
  vim.cmd("botright new")
  Panel.windows.bottom_left = vim.api.nvim_get_current_win()

  Panel.windows.bottom_right = vim.api.nvim_open_win(0, false, {
    win = Panel.windows.bottom_left,
    split = "right"
  })

  vim.api.nvim_set_current_win(Panel.windows.main)
end

function Panel.open_overseer()
  if Panel.windows.bottom_left == nil or Panel.windows.bottom_right == nil then
    Panel.open_bottom_box()
  end

  require("overseer").toggle({
    enter = false
  })

  vim.schedule(function()
    Panel.print_buffers()

    Panel.contents.bottom_left = "OverseerList"
    Panel.move_buf_into_win(
      Panel.windows.bottom_left,
      Panel.get_buf_by_filetype(Panel.contents.bottom_left)
    )

    Panel.print_buffers()

    Panel.contents.bottom_right = "OverseerOutput"
    Panel.move_buf_into_win(
      Panel.windows.bottom_right,
      Panel.get_buf_by_filetype(Panel.contents.bottom_right)
    )

    Panel.cleanup_wins()
  end)
end

function Panel.open_dap()
  if Panel.bottom_box_is_empty then
    require("dapui").open()--  TODO: create open function for dap

  else
    require("dapui").open()
    Panel.switch_dap_and_overseer(1)
  end
end

function Panel.apply_layout()
  --vim.api.nvim_win_set_width(Panel.neotree, 30)
end

function Panel.hide_overseer()
  vim.api.nvim_win_hide(Panel.overseer)
  Panel.overseer = nil
end

function Panel.set_buf(file)
  local buf = vim.fn.bufadd(file)
  vim.api.nvim_win_set_buf(Panel.win, buf)
end

function Panel.set_buf_and_open(file)
  local buf = vim.fn.bufadd(file)
  vim.api.nvim_win_set_buf(Panel.win, buf)
  vim.api.nvim_set_current_win(Panel.win)
end

function Panel.switch_dap_and_overseer(target)
  local win_left = Panel.win_bot_left
  local win_right = Panel.win_bot_right
  local buf_left = nil
  local buf_right = nil
  local order = {
    { -- 1 -> Insert Dap
      "OverseerList",
      "OverseerOutput",
      "dap-repl",
      "dapui_console"
    },
    { -- 2 -> Insert Overseer
      "dap-repl",
      "dapui_console",
      "OverseerList",
      "OverseerOutput"
    }
  }

  vim.schedule(function()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      print(
        "win: ", vim.fn.win_findbuf(buf),
        "buf: " , buf,
        "name: " , vim.api.nvim_buf_get_name(buf),
        "filetype: " , vim.bo[buf].filetype
      )
      if vim.bo[buf].filetype == order[target][1] then
        win_left = Panel.get_win_from_buf(buf)
      end
      if vim.bo[buf].filetype == order[target][2] then
        win_right = Panel.get_win_from_buf(buf)
      end
      if vim.bo[buf].filetype == order[target][3] then
        buf_left = buf
      end
      if vim.bo[buf].filetype == order[target][4] then
        buf_right = buf
        local old_dap_console_win = Panel.get_win_from_buf(buf)
        vim.api.nvim_win_set_buf(overseer_output_win, buf)
        vim.api.nvim_win_close(old_dap_console_win, true)
      end
    end

    -- set win_left
    local win_old_left = Panel.get_win_from_buf(buf_left)
    vim.api.nvim_win_set_buf(win_left, buf_left)
    vim.api.nvim_win_close(win_old_left, true)

    -- set win_right
    local win_old_right = Panel.get_win_from_buf(buf_right)
    vim.api.nvim_win_set_buf(win_right, buf_right)
    vim.api.nvim_win_close(win_old_right, true)
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
end

function Panel.print_buffers()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    print(
      "win: ", vim.fn.win_findbuf(buf),
      "buf: " , buf,
      "name: " , vim.api.nvim_buf_get_name(buf),
      "filetype: " , vim.bo[buf].filetype
    )
  end
end

-- Moves selected buf into targeted window and closes side product window
function Panel.move_buf_into_win(target_win, buf)
  if vim.api.nvim_win_is_valid(target_win) == false then
    vim.notify("Win[" .. target_win .. "] is not valid",
      vim.log.levels.WARN,
      {
        title = "Panel::move_buf_into_win"
      }
    )
    return
  end

  vim.notify(buf)
  if vim.api.nvim_buf_is_valid(buf) == false then
    vim.notify("Buffer[" .. buf .. "] is not valid",
      vim.log.levels.WARN,
      {
        title = "Panel::move_buf_into_win"
      }
    )
    return
  end

  table.insert(Panel.cleanup_windows, Panel.get_win_from_buf(buf))
  vim.api.nvim_win_set_buf(target_win, buf)
end

return Panel
