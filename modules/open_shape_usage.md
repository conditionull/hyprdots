## open_shape.lua usage

`open_shape` opens a command, waits for the new window, then shapes it. You can float it, resize it, move it, tag it, or send it to another workspace.

### Rules

| Situation | Use |
| --- | --- |
| One window in one bind | `class` should be enough |
| Multiple windows from the same app in one bind | Use `class` + `title` |
| Need to target the window later | Add `params.tag` |
| Need workspace 6 silent | Use `params = { workspace = 6, silent = true }` |

### Basic format

```lua
open_shape.open({
  cmd = "command to run",

  class = "firefox",
  title = "optional Lua title pattern",

  size = { width, height },
  move = { x, y },

  params = {
    tag = "optional-tag",
    workspace = 6,
    silent = true,
  },
})
```

### Options

| Option | Required | Default | Notes |
| --- | --- | --- | --- |
| `cmd` | Yes | none | Command to open the app/window |
| `class` | Usually | none | Best simple matcher, like `class = "firefox"` |
| `title` | Optional | none | Best when one bind opens <u>multiple</u> windows from the same app |
| `initialClass` | Optional | none | Match the starting class instead of the current class |
| `initialTitle` | Optional | none | Match the starting title instead of the current title |
| `match` | Optional | none | Custom function for special matching |
| `float` | Optional | `true` | Use `float = false` to keep the window tiled |
| `size` | Optional | omitted | `{ width, height }` |
| `move` | Optional | omitted | `{ x, y }` |
| `timeout` | Optional | `2500` | Cleanup timer in ms |
| `params` | Optional | omitted | Extra options: `tag`, `workspace`, `silent` |


### Timeout

`timeout` is optional. Use it when a page title may take longer to update. If omitted, it defaults to `2500`.


```lua
timeout = 5000
```

### Title patterns

`title` uses Lua patterns. For normal titles, the main thing to remember is that `-` should be written as `%-`.

| Use | To match |
| --- | --- |
| `%-` | `-` |
| `%.` | `.` |
| `%%` | `%` |
| `%(` / `%)` | `(` / `)` |
| `%+` | `+` |
| `%?` | `?` |

Example:

```lua
title = twitch_name .. " %- Chat %- Twitch"
```

Matches something like:

```text
twitch_name - Chat - Twitch
```

### Single window example

Use this when the bind opens <u>one</u> new window. Since this bind only opens <u>one</u> Firefox window, `class = "firefox"` is enough.

This shows a custom tag and workspace 6 silent usage:

```lua
hl.bind(mainMod .. " + SHIFT + L", function()
  open_shape.open({
    cmd = "firefox --new-window https://www.youtube.com",

    class = "firefox",

    size = { 500, 500 },
    move = { 1279, 199 },

    params = {
      tag = "youtube-popout",
      workspace = 6,
      silent = true,
    },
  })
end)
```

### Multiple windows in one bind

Use `title` when one bind opens multiple windows from the same app. This prevents the chat window from getting the activity feed size/position, or the other way around.

```lua
hl.bind(mainMod .. " + SHIFT + T", function()
  open_shape.open({
    cmd = "firefox --new-window '" .. twitch_activity_url .. "'",

    class = "firefox",
    title = "Activity Feed %- Twitch",

    size = { 570, 500 },
    move = { 3195, 214 },
  })

  open_shape.open({
    cmd = "firefox --new-window '" .. "www.twitch.tv/popout/" .. twitch_name .. "/chat?popout=" .. "'",

    class = "firefox",
    title = twitch_name .. " %- Chat %- Twitch",

    size = { 500, 680 },
    move = { 1931, 389 },
  })

  open_shape.open({
    cmd = "google-chrome-stable --new-window https://sayonari.github.io/jimakuChan",

    class = "google-chrome",
    title = "jimakuChan",

    size = { 935, 296 },
    move = { 2895, 46 },
  })
end)
```

### Minimal example

Most options can be omitted:

```lua
hl.bind(mainMod .. " + SHIFT + Y", function()
  open_shape.open({
    cmd = "firefox --new-window https://www.youtube.com",
    class = "firefox",
    size = { 500, 500 },
    move = { 1279, 199 },
  })
end)
```

This works because `float` defaults to `true`, `timeout` defaults to `2500`, and `params` / `title` are optional.

### Custom match function

Use `match` for advanced cases where `class` / `title` are not specific enough.

Example: match YouTube, but not YouTube Shorts:

```lua
open_shape.open({
  cmd = "firefox --new-window https://www.youtube.com",

  match = function(w)
    local title = w.title or ""

    return w.class == "firefox"
      and title:match("YouTube")
      and not title:match("Shorts")
  end,

  size = { 500, 500 },
  move = { 1279, 199 },
})
```

One small note: since `match` takes over matching, you don’t need to set:

```lua
class = "firefox"
title = "YouTube"
```