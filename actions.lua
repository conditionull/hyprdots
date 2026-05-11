local M = {}

-- Helper function for shaping windows after launch.
-- Useful when windows lack a unique initial title/class for standard window rules.
local function shape_window(opts)
  local window = opts.window

  if opts.float ~= false then
    hl.dispatch(hl.dsp.window.float({
      action = "set",
      window = window,
    }))
  end

  if opts.size then
    hl.dispatch(hl.dsp.window.resize({
      x = opts.size[1],
      y = opts.size[2],
      relative = false,
      window = window,
    }))
  end

  if opts.move then
    hl.dispatch(hl.dsp.window.move({
      x = opts.move[1],
      y = opts.move[2],
      relative = false,
      window = window,
    }))
  end

  if opts.z then
    hl.dispatch(hl.dsp.window.alter_zorder({
      mode = opts.z,
      window = window,
    }))
  end
end

function M.spawn_and_shape(opts)
  hl.exec_cmd(opts.cmd)

  hl.timer(function()
    shape_window(opts)
  end, {
    timeout = opts.delay or 1000,
    type = "oneshot",
  })
end

return M
