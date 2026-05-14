local M = {}

local pending = {}

local function remove_pending(request)
  for i, item in ipairs(pending) do
    if item == request then
      table.remove(pending, i)
      return
    end
  end
end

local function shape_window(w, opts)
  local params = opts.params or {}

  if w == nil or w.address == nil then
    return
  end

  local target = "address:" .. w.address

  local function setup()
    if params.tag then
      hl.dispatch(hl.dsp.window.tag({
        tag = params.tag,
        window = target,
      }))
    end

    if opts.float ~= false then
      hl.dispatch(hl.dsp.window.float({
        action = "enable",
        window = target,
      }))
    end

    if params.workspace then
      hl.dispatch(hl.dsp.window.move({
        workspace = params.workspace,
        follow = not params.silent,
        window = target,
      }))
    end
  end

  local function resize()
    if opts.size then
      hl.dispatch(hl.dsp.window.resize({
        x = opts.size[1],
        y = opts.size[2],
        relative = false,
        window = target,
      }))
    end
  end

  local function move()
    if opts.move then
      hl.dispatch(hl.dsp.window.move({
        x = opts.move[1],
        y = opts.move[2],
        relative = false,
        window = target,
      }))
    end
  end

  local function geometry()
    resize()

    hl.timer(move, {
      timeout = 25,
      type = "oneshot",
    })
  end

  setup()
  geometry()

  hl.timer(geometry, {
    timeout = 250,
    type = "oneshot",
  })

  hl.timer(geometry, {
    timeout = 600,
    type = "oneshot",
  })

  hl.timer(move, {
    timeout = 900,
    type = "oneshot",
  })
end

local function basic_matches_window(w, opts)
  if opts.class and w.class ~= opts.class then
    return false
  end

  if opts.initialClass and w.initialClass ~= opts.initialClass then
    return false
  end

  return true
end

local function final_matches_window(w, opts)
  if not basic_matches_window(w, opts) then
    return false
  end

  if opts.title and not (w.title or ""):match(opts.title) then
    return false
  end

  if opts.initialTitle and not (w.initialTitle or ""):match(opts.initialTitle) then
    return false
  end

  if opts.match and not opts.match(w) then
    return false
  end

  return true
end

local function try_shape_pending(w)
  if w == nil or w.address == nil then
    return
  end

  for i, request in ipairs(pending) do
    if request.candidates[w.address] and final_matches_window(w, request.opts) then
      shape_window(w, request.opts)

      if request.timer ~= nil then
        request.timer:set_enabled(false)
      end

      table.remove(pending, i)
      return
    end
  end
end

hl.on("window.open", function(w)
  if w == nil or w.address == nil then
    return
  end

  for _, request in ipairs(pending) do
    if basic_matches_window(w, request.opts) then
      request.candidates[w.address] = true
    end
  end

  try_shape_pending(w)
end)

hl.on("window.title", function(w)
  try_shape_pending(w)
end)

function M.open(opts)
  local request = {
    opts = opts,
    timer = nil,
    candidates = {},
  }

  table.insert(pending, request)

  local timeout = opts.timeout or 2500
  
  request.timer = hl.timer(function()
    remove_pending(request)
  end, {
    timeout = timeout,
    type = "oneshot",
  })

  hl.exec_cmd(opts.cmd)
end

return M