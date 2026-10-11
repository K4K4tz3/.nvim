local Panel = {
  win = nil,
  neotree = nil,

  windows = {
    main = nil,
    neotree = nil,
  },
  buffer = {
    main = nil,
    neotree = nil,
  }
}

function Panel.test()
  if Panel.win != nil then
    return win
  else
    Panel.win = vim.api.nvim_get_current_win()
    local buf = vim.api.nvim_create_buf(false, false)
    vim.api.nvim_buf_set_lines(buf, 0, 1, false, {
      "Hello from panel A",
    })
    vim.api.nvim_win_set_buf(Panel.win, buf)
  end
end

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

function Panel.set_overseer(task)
  local buf_overseer_list = Panel.get_buf_by_filetype("OverseerList")

  if buf_overseer_list then
    Panel.buffer.bottom_left = buf_overseer_list
    local win = Panel.get_win_from_buf(buf_overseer_list)

    if win then
      Panel.windows.bottom_left = win
    end
  end
end

function Panel.apply_layout()
  vim.api.nvim_win_set_width(Panel.windows.neotree, 30)
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

return Panel
