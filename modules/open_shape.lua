local M = {}

local function shape_window(opts, timer, attempts)
  attempts.count = attempts.count + 1

  local w = hl.get_window(opts.window)

  if w == nil or w.address == nil then
    if attempts.count >= (opts.attempts or 40) and timer.ref ~= nil then
      timer.ref:set_enabled(false)
    end

    return
  end

  local target = "address:" .. w.address

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

  if timer.ref ~= nil then
    timer.ref:set_enabled(false)
  end
end

function M.open(opts)
  local timer = { ref = nil }
  local attempts = { count = 0 }

  hl.exec_cmd(opts.cmd)

  timer.ref = hl.timer(function()
    shape_window(opts, timer, attempts)
  end, {
    timeout = opts.interval or 250,
    type = "repeat",
  })
end

return M