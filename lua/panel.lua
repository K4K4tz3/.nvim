local Panel = {
  win = nil,
  neotree = nil,
  overseer = nil,
  overseer_buf = nil,
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
  Panel.win = vim.api.nvim_get_current_win()
  if Panel.win == nil then
    return
  end

  Panel.create_neotree()
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

function Panel.create_overseer()
  Panel.overseer = vim.api.nvim_open_win(0, false, {
    split = "below",
    win = -1,
    height = 25
  })

  require("overseer").toggle({
    winid = Panel.overseer,
  })
  Panel.overseer_buf = vim.api.nvim_win_get_buf(Panel.overseer)
end

function Panel.apply_layout()
  vim.api.nvim_win_set_width(Panel.neotree, 30)
end

function Panel.hide_overseer()
  vim.api.nvim_win_hide(Panel.overseer)
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

return Panel
