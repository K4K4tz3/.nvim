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

  vim.api.nvim_create_user_command(
    'PanelOpenNeotree',
    Panel.open_neotree,
    {}
  )
  vim.api.nvim_create_user_command(
    'PanelHideNeotree',
    Panel.hide_neotree,
    {}
  )

  Panel.open_neotree()
end

function Panel.apply_layout()
  if Panel.windows.neotree then
    vim.api.nvim_win_set_width(Panel.windows.neotree, 30)
  end

  if Panel.windows.bottom_left ~= nil then
    vim.api.nvim_win_set_height(Panel.windows.bottom_left, 10)
    vim.api.nvim_win_set_width(Panel.windows.bottom_left, 60)
  end

  if Panel.windows.bottom_right ~= nil then
    vim.api.nvim_win_set_height(Panel.windows.bottom_right, 10)
  end
end

-- Cleans up windows that might not get closed before
function Panel.cleanup()
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

--
-- Neotree
--
function Panel.open_neotree()
  if not Panel.windows.neotree -- create neotree window
      or (Panel.windows.neotree and not vim.api.nvim_win_is_valid(Panel.windows.neotree)) then
    Panel.windows.neotree = vim.api.nvim_open_win(0, true, {
      split = "left",
      win = -1,
      width = 30,
    })
  end

  if not Panel.contents.neotree
      or (Panel.contents.neotree and (not vim.api.nvim_buf_is_valid(Panel.contents.neotree) or vim.bo[Panel.contents.neotree].filetype ~= "neo-tree")) then
    require("neo-tree.command").execute({
      action = "focus",
      source = "filesystem",
      position = "current",
    })

    Panel.contents.neotree = Panel.get_buf_by_filetype("neo-tree")

    vim.api.nvim_set_current_win(Panel.windows.main)
  end
end

function Panel.hide_neotree()
  if Panel.windows.neotree and vim.api.nvim_win_is_valid(Panel.windows.neotree) then
    -- check if buf exists
    if Panel.contents.neotree and vim.api.nvim_buf_is_valid(Panel.contents.neotree) then
      Panel.contents.neotree = nil
    end

    -- close and set nil
    vim.api.nvim_win_close(Panel.windows.neotree, true)
    Panel.windows.neotree = nil
  end
end

--
-- Overseer
--

function Panel.open_bottom_box()
  -- if both do not exist create left
  if not Panel.check_win(Panel.windows.bottom_left) and not Panel.check_win(Panel.windows.bottom_right) then
    vim.cmd("botright new")
    Panel.windows.bottom_left = vim.api.nvim_get_current_win()
  end

  if not Panel.check_win(Panel.windows.bottom_left) then
    Panel.windows.bottom_left = vim.api.nvim_open_win(vim.api.nvim_create_buf(false, true), false, {
      win = Panel.windows.bottom_right,
      split = "left"
    })
  elseif not Panel.check_win(Panel.windows.bottom_right) then
    Panel.windows.bottom_right = vim.api.nvim_open_win(vim.api.nvim_create_buf(false, true), false, {
      win = Panel.windows.bottom_left,
      split = "right"
    })
  end

  vim.api.nvim_set_current_win(Panel.windows.main)
end

function Panel.open_overseer()
  if Panel.windows.bottom_left == nil or Panel.windows.bottom_right == nil then
    Panel.open_bottom_box()
  end

  require("overseer").toggle({
    enter = false
  })


  Panel.contents.bottom_left = "OverseerList"
  Panel.move_buf_into_win(
    Panel.windows.bottom_left,
    Panel.get_buf_by_filetype(Panel.contents.bottom_left)
  )


  Panel.contents.bottom_right = "OverseerOutput"
  Panel.move_buf_into_win(
    Panel.windows.bottom_right,
    Panel.get_buf_by_filetype(Panel.contents.bottom_right)
  )

  Panel.cleanup()
end

function Panel.open_dap()
  -- TODO: open dap and insert dap-repl and dap_console into bottom boxes
end

function Panel.hide_overseer()
  -- TODO: close the bottom boxes and nil the variables
  -- TODO: add hide func for dap
  -- TODO: add hide for both
end

function Panel.set_buf(file)
  local buf = vim.fn.bufadd(file)
  vim.api.nvim_win_set_buf(Panel.windows.main, buf)
end

function Panel.set_buf_and_open(file)
  Panel.set_buf(file)
  vim.api.nvim_set_current_win(Panel.windows.main)
end

--
-- Helpers
--

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

function Panel.print_buffers()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    print(
      "win: ", vim.fn.win_findbuf(buf),
      "buf: ", buf,
      "name: ", vim.api.nvim_buf_get_name(buf),
      "filetype: ", vim.bo[buf].filetype
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
