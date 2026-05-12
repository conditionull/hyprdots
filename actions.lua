local M = {}

local function get_target_window(selector)
  local ok, win = pcall(function()
    return hl.get_window(selector)
  end)

  if not ok or not win or not win.address then
    return nil
  end

  return "address:" .. win.address
end

local function shape_window(opts)
  local target = get_target_window(opts.window)

  if not target then
    return false
  end

  -- focus the target first
  -- move/resize are most reliable when applied to the active window
  hl.dispatch(hl.dsp.focus({
    window = target,
  }))

  if opts.float ~= false then
    hl.dispatch(hl.dsp.window.float({
      action = "set",
    }))
  end

  if opts.size then
    hl.dispatch(hl.dsp.window.resize({
      x = opts.size[1],
      y = opts.size[2],
      relative = false,
    }))
  end

  if opts.move then
    hl.dispatch(hl.dsp.window.move({
      x = opts.move[1],
      y = opts.move[2],
      relative = false,
    }))
  end

  if opts.z then
    hl.dispatch(hl.dsp.window.alter_zorder({
      mode = opts.z,
    }))
  end

  return true
end

function M.spawn_and_shape(opts)
  hl.exec_cmd(opts.cmd)

  local attempts = 0
  local max_attempts = opts.attempts or 40
  local interval = opts.interval or 250

  local function try_shape()
    attempts = attempts + 1

    if shape_window(opts) then
      return
    end

    if attempts < max_attempts then
      hl.timer(try_shape, {
        timeout = interval,
        type = "oneshot",
      })
    end
  end

  hl.timer(try_shape, {
    timeout = opts.delay or interval,
    type = "oneshot",
  })
end

return M
