-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("NVD_BACKEND", "direct")
hl.env("AQ_FORCE_LINEAR_BLIT", "0")
hl.env("GTK_THEME", "Fluent-Dark-compact")

hl.env("HYPRCURSOR_THEME", "AC-Future")
hl.env("XCURSOR_THEME", "AC-Future")
hl.env("HYPRCURSOR_SIZE", "40")
hl.env("XCURSOR_SIZE", "40")

-------------------
---- FUNCTIONS ----
-------------------
local actions = require("actions")
local ok, private = pcall(require, "private")
if not ok then
  private = {}
end

local function force_stack(dir)
  return function()
    hl.dispatch(hl.dsp.layout("togglesplit"))
    hl.dispatch(hl.dsp.window.swap({ direction = dir }))
  end
end

--------------------------
---- CONFIG VARIABLES ----
--------------------------
local terminal = "kitty"
local fileManager = "thunar"
local menu = "vicinae toggle"
local leftMonitor = "DP-3"
local rightMonitor = "DP-1"
local floatingKittyW = 900
local floatingKittyH = 560
local twitch_name = private.twitch_name or ""
local twitch_uuid = private.twitch_uuid or ""
local twitch_activity_url =
  "https://dashboard.twitch.tv/popout/u/"
  .. twitch_name
  .. "/stream-manager/activity-feed?uuid="
  .. twitch_uuid


------------------
---- MONITORS ----
------------------
hl.monitor({
  output = leftMonitor,
  mode = "1920x1080@144",
  position = "0x0",
  scale = "1",
})

hl.monitor({
  output = rightMonitor,
  mode = "1920x1080@165",
  position = "1920x0",
  scale = "1",
})

hl.workspace_rule({ workspace = "1", monitor = leftMonitor })
hl.workspace_rule({ workspace = "2", monitor = rightMonitor })
hl.workspace_rule({ workspace = "8", monitor = rightMonitor })


-------------------
---- AUTOSTART ----
-------------------
hl.on("hyprland.start", function ()
  hl.exec_cmd("waybar -c ~/.config/waybar/config_dock -s ~/.config/waybar/dock.css")
  hl.exec_cmd("awww-daemon & mako & vicinae server")
  hl.exec_cmd("systemctl --user start hyprpolkitagent")

  hl.exec_cmd("systemctl --user enable --now wayscriber.service")

  hl.exec_cmd("xrandr --output DP-3 --primary")

  hl.exec_cmd("wl-clip-persist --clipboard regular")
  hl.exec_cmd("wl-paste --type text --watch cliphist store")
  hl.exec_cmd("wl-paste --type image --watch cliphist store")
end)


---------------
---- INPUT ----
---------------
hl.config({
  input = {
    kb_layout  = "us",
    follow_mouse = 1,
    sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.
  },
  binds = {
    allow_workspace_cycles = true,
  },
})


-----------------------
---- LOOK AND FEEL ----
-----------------------
hl.config({
  general = {
    gaps_in = 3, -- gaps between windows
    gaps_out = 4, -- gaps between windows and monitor edges
    float_gaps = 0, -- gaps for floating windows
    border_size = 0,

    col = {
      active_border = "rgba(39,40,54,0.5)",
    },

    layout = "dwindle",
  },

  decoration = {
    rounding = 12,

    shadow = {
      enabled = true,
      range = 5,
    },

    blur = {
      enabled = true,
      new_optimizations = true,
      size = 4,
      passes = 3,
    },
  },

  dwindle = {
    preserve_split = true,
  },

  animations = {
    enabled = true,
  },
})

hl.layer_rule({
  match = { namespace = "vicinae" },
  name = "vicinae-blur",
  blur = true,
  ignore_alpha = 0,
})

-- Default curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve( "rubber", { type = "spring", mass = 1, stiffness = 70, dampening = 10 } )
hl.animation({ leaf = "windows", enabled = true, speed = 5, spring = "rubber", style = "popin 80%" })

---------------------
---- KEYBINDINGS ----
---------------------
local mainMod = "SUPER"

-- Apps
hl.bind(mainMod .. " + Q",               hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + SHIFT + Q",       hl.dsp.exec_cmd(terminal .. " --class floating-kitty"))
hl.bind(mainMod .. " + E",               hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + R",               hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + M",               hl.dsp.exec_cmd("pavucontrol"))
hl.bind(mainMod .. " + B",               hl.dsp.exec_cmd("/usr/lib/firefox/firefox"))
hl.bind(mainMod .. " + D",               hl.dsp.exec_cmd("wayscriber --daemon-toggle"))

-- Browser
hl.bind(mainMod .. " + Y",               hl.dsp.exec_cmd("firefox --new-tab https://www.youtube.com/"))
hl.bind(mainMod .. " + T",               hl.dsp.exec_cmd("firefox --new-tab https://www.twitch.tv/"))

hl.bind(mainMod .. " + SHIFT + T", function()
  actions.spawn_and_shape({
    cmd = "firefox --new-window '" .. twitch_activity_url .. "'",

    window = "title:.*Activity Feed - Twitch.*",

    size = { 570, 500 },
    move = { 3195, 214 },

    delay = 1000,
  })
end)

hl.bind(mainMod .. " + SHIFT + J", hl.dsp.exec_cmd(
  "google-chrome-stable --new-window https://sayonari.github.io/jimakuChan"
))

hl.bind(mainMod .. " + G",               hl.dsp.exec_cmd("firefox --new-tab https://www.github.com/"))

-- Waybar
hl.bind(mainMod .. " + W",               hl.dsp.exec_cmd("waybar -c ~/.config/waybar/config_dock -s ~/.config/waybar/dock.css"))
hl.bind(mainMod .. " + SHIFT + W",       hl.dsp.exec_cmd("pkill -x waybar"))
hl.bind(mainMod .. " + SHIFT + B",       hl.dsp.exec_cmd("~/.config/waybar/scripts/waybar-selector.sh"))

-- Window management
hl.bind(mainMod .. " + C",               hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + C",       hl.dsp.window.kill())
hl.bind(mainMod .. " + V",               hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P",               hl.dsp.window.pin())
hl.bind(mainMod .. " + F",               hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind(mainMod .. " + SHIFT + F",       hl.dsp.window.fullscreen({ mode = "fullscreen" }))

-- Window rounding
hl.bind(mainMod .. " + CTRL + O",        hl.dsp.window.set_prop({ prop = "rounding", value = "0" }))
hl.bind(mainMod .. " + CTRL + SHIFT + O",hl.dsp.window.set_prop({ prop = "rounding", value = "unset" }))

-- Focus
hl.bind(mainMod .. " + left",            hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right",           hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",              hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",            hl.dsp.focus({ direction = "down" }))

-- Move windows
hl.bind(mainMod .. " + SHIFT + left",    hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + right",   hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + up",      hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + down",    hl.dsp.window.move({ direction = "down" }))

-- Resize windows
hl.bind(mainMod .. " + CTRL + left",     hl.dsp.window.resize({ x = -50,  y = 0, relative = true }),    { repeating = true })
hl.bind(mainMod .. " + CTRL + right",    hl.dsp.window.resize({ x = 50,   y = 0, relative = true }),    { repeating = true })
hl.bind(mainMod .. " + CTRL + up",       hl.dsp.window.resize({ x = 0,    y = -50, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + down",     hl.dsp.window.resize({ x = 0,    y = 50, relative = true }),  { repeating = true })

-- Move/resize with mouse
hl.bind(mainMod .. " + mouse:272",       hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273",       hl.dsp.window.resize(), { mouse = true })

-- Layout
hl.bind(mainMod .. " + CTRL + F",              hl.dsp.layout("swapsplit"))
hl.bind(mainMod .. " + CTRL + SHIFT + down", force_stack("d"))
hl.bind(mainMod .. " + CTRL + SHIFT + up",   force_stack("u"))

-- Workspaces
for i = 1, 9 do
    hl.bind(mainMod .. " + " .. i,             hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. i,     hl.dsp.window.move({ workspace = i }))
end
hl.bind(mainMod .. " + TAB",                   hl.dsp.focus({ workspace = "m+1" }))
hl.bind(mainMod .. " + SHIFT + TAB",           hl.dsp.focus({ workspace = "m-1" }))

-- System
hl.bind(mainMod .. " + L",                     hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + CTRL + SHIFT + R",      hl.dsp.exec_cmd("vicinae server --replace"))
hl.bind(mainMod .. " + CTRL + SHIFT + M",      hl.dsp.exit())
hl.bind(mainMod .. " + CTRL + SHIFT + P",      hl.dsp.exec_cmd("poweroff"))

-- Screenshot
hl.bind(mainMod .. " + SHIFT + S",             hl.dsp.exec_cmd('bash -c \'dir=~/Screenshots; mkdir -p "$dir"; area=$(slurp); [ -n "$area" ] && grim -g "$area" - | tee "$dir/$(date +%Y-%m-%d_%H-%M-%S).png" | wl-copy && notify-send -t 1400 "Screenshot copied to clipboard"\''))

-- Color picker
hl.bind(mainMod .. " + SHIFT + P",             hl.dsp.exec_cmd("~/.config/hypr/scripts/hyprpicker.sh"))

-- Audio
hl.bind(mainMod .. " + A",                     hl.dsp.exec_cmd("~/.config/hypr/scripts/pogo-sink-switch.sh"))
hl.bind(mainMod .. " + CTRL + SHIFT + V",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
hl.bind("XF86AudioRaiseVolume",                hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 1%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",                hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",                       hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })

hl.bind("XF86AudioNext",                       hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause",                      hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",                       hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",                       hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

-- Wayvibes
hl.bind(mainMod .. " + SHIFT + K",             hl.dsp.exec_cmd("wayvibes ~/workspace/github/public/wayvibes/soundpacks/nk-cream/ -v 0.8"))
hl.bind(mainMod .. " + CTRL + SHIFT + K",      hl.dsp.exec_cmd("pkill -x wayvibes"))

-- Soundboard
hl.bind(mainMod .. " + SHIFT + D",             hl.dsp.exec_cmd("mpv --volume=75 --no-video --keep-open=no --audio-device=pulse/SOUNDBOARDSINK ~/Downloads/cinematicboom.mp3"))
hl.bind(mainMod .. " + SHIFT + G",             hl.dsp.exec_cmd("mpv --volume=40 --no-video --keep-open=no --audio-device=pulse/SOUNDBOARDSINK ~/Downloads/vine-boom.mp3"))

-- Quick access (config files)
hl.bind(mainMod .. " + H",                     hl.dsp.exec_cmd(terminal .. " nvim ~/.config/hypr/hyprland.lua"))
hl.bind(mainMod .. " + N",                     hl.dsp.exec_cmd(terminal .. " nvim ~/.config/nvim/init.lua"))
hl.bind(mainMod .. " + SHIFT + H",             hl.dsp.exec_cmd(terminal .. " --directory ~/.config/hypr/"))
hl.bind(mainMod .. " + SHIFT + N",             hl.dsp.exec_cmd(terminal .. " --directory ~/.config/nvim/"))

-- Selector
hl.bind(mainMod .. " + SHIFT + R",             hl.dsp.exec_cmd("selector.sh"))


--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------
-- Opacity rules
hl.window_rule({ match = { initial_class = "[Tt]hunar" },                    opacity = "1 0.8" })
hl.window_rule({ match = { initial_class = "org.pulseaudio.pavucontrol" },   opacity = "1 0.8" })
hl.window_rule({ match = { class = "kitty" },                                opacity = "0.8 0.6" })
hl.window_rule({ match = { class = "floating-kitty" },                       opacity = "0.8 0.6" })

-- Floating terminal (cursor-centered + persistent size)
hl.window_rule({
  match = { initial_class = "floating-kitty" },
  float = true,
  size  = { floatingKittyW, floatingKittyH },
  move  = {
    "cursor_x-(" .. floatingKittyW .. "*0.5)",
    "cursor_y-(" .. floatingKittyH .. "*0.5)",
  },
})

-- General app float/size/center rules
hl.window_rule({ match = { initial_class = "it.mijorus.gearlever" },          float = true, size = { 840, 540 } })
hl.window_rule({ match = { initial_class = "org.openrgb.OpenRGB" },           float = true, center = true, size = { 1230, 880 } })
hl.window_rule({ match = { initial_class = "[Tt]hunar" },                     float = true, center = true, size = { 930, 740 } })
hl.window_rule({ match = { initial_class = "org.pulseaudio.pavucontrol" },    size = { 930, 740 } })
hl.window_rule({ match = { initial_class = "recorder-picker" },               float = true, center = true, size = { 500, 250 }, stay_focused = true })
hl.window_rule({ match = { initial_class = "waybar-selector" },               float = true, center = true, size = { 460, 140 } })
hl.window_rule({ match = { initial_class = "com.github.PintaProject.Pinta" }, float = true, center = true, size = { 1660, 930 } })
hl.window_rule({ match = { initial_class = "gcr-prompter" },                  stay_focused = true })
hl.window_rule({ match = { initial_class = "Bitwarden" },                     float = true, center = true, size = { 1350, 840 } })
hl.window_rule({ match = { initial_class = "LosslessCut" },                   float = true, center = true, size = { 1500, 900 } })
hl.window_rule({ match = { initial_class = "mpv" },                           float = true, center = true, size = { 1500, 900 } })
hl.window_rule({ match = { initial_class = "hyprland-share-picker" },         float = true, center = true, size = { 500, 550 } })
hl.window_rule({ match = { initial_class = "wootility" },                     float = true, center = true, size = { 1650, 980 } })
hl.window_rule({ match = { initial_class = "discord" },                       float = true, center = true, size = { 1700, 1000 } })
hl.window_rule({ match = { initial_class = "Video Trimmer" },                 float = true, center = true, size = { 1294, 910 } })

-- Split tracker
hl.window_rule({ match = { initial_title = "Junker's Split Tracker.*" },     float = true, center = true, size = { 970, 780 } })
hl.window_rule({
    name  = "pogo-split-overlay",
    match = { initial_class = "pogostuck-split-tracker", initial_title = "split-overlay" },
    float       = true,
    pin         = true,
    no_blur     = true,
    no_shadow   = true,
    border_size = 0,
    move        = { 1500, 6 },
    size        = { 416, 223 },
})

-- File dialogs (xdg-desktop-portal-gtk)
hl.window_rule({ match = { initial_class = "xdg-desktop-portal-gtk", initial_title = "Open file" },         float = true, center = true, size = { 1450, 900 } })
hl.window_rule({ match = { initial_class = "xdg-desktop-portal-gtk", initial_title = "Save a File" },       float = true, center = true, size = { 1100, 700 } })
hl.window_rule({ match = { initial_class = "xdg-desktop-portal-gtk", initial_title = "Save Image" },        float = true, center = true, size = { 980, 730 } })
hl.window_rule({ match = { initial_class = "xdg-desktop-portal-gtk", initial_title = "Local File" },        float = true, center = true, size = { 1450, 900 } })
hl.window_rule({ match = { initial_class = "xdg-desktop-portal-gtk", initial_title = "Pick game to add" },  float = true, center = true, size = { 800, 600 } })

-- Firefox
hl.window_rule({ match = { initial_class = "firefox", initial_title = "Picture-in-Picture" }, float = true, size = { 680, 382 } })
hl.window_rule({ match = { initial_class = "firefox", initial_title = "Library" },            float = true, center = true, size = { 910, 910 } })

-- Blender
hl.window_rule({ match = { initial_class = "blender", title = "Preferences" }, float = true, center = true })

-- Minecraft / launchers
hl.window_rule({ match = { initial_class = "org.multimc.MultiMC" },             float = true, center = true, size = { 845, 645 } })
hl.window_rule({ match = { initial_class = "org.prismlauncher.PrismLauncher" }, float = true, center = true, size = { 845, 645 } })
hl.window_rule({ match = { initial_class = "Minecraft.*" },                     monitor = leftMonitor })

-- Steam
hl.window_rule({ match = { initial_class = "steam_app_.*" },                                monitor = leftMonitor })
hl.window_rule({ match = { initial_title = "VTube Studio" },                                monitor = rightMonitor, workspace = "5 silent", fullscreen = true })
hl.window_rule({ match = { initial_title = "Steam",          initial_class = "steam" },     tile = true })
hl.window_rule({ match = { initial_title = "Steam Settings", initial_class = "steam" },     float = true, center = true })
hl.window_rule({ match = { initial_title = "Sign in to Steam" },                            center = true })
hl.window_rule({ match = { initial_title = "Image Popout",   initial_class = "steam" },     float = true, center = true })
hl.window_rule({ match = { initial_title = "Friends List",   initial_class = "steam" },     float = true, center = true })
hl.window_rule({ match = { initial_title = "Shutdown",       initial_class = "steam" },     center = true })
hl.window_rule({ match = { initial_title = "Special Offers", initial_class = "steam" },     center = true })
hl.window_rule({ match = { initial_title = "Add Non-Steam Game", initial_class = "steam" }, float = true, center = true, size = { 700, 650 } })

-- Spotify
hl.window_rule({ match = { initial_class = "[Ss]potify" }, monitor = rightMonitor, workspace = "9 silent" })

-- Streamer.bot
hl.window_rule({ match = { initial_title = "Streamer.bot.*" },                 workspace = "8 silent" })
hl.window_rule({ match = { class = "streamer.bot.exe", title = "Add Action" }, fullscreen = false })

-- Telegram
hl.window_rule({ match = { initial_class = "org.telegram.desktop" },                                 float = true, size = { 635, 802 } })
hl.window_rule({ match = { initial_class = "org.telegram.desktop", initial_title = "Media viewer" }, float = true, size = { 850, 850 } })
hl.window_rule({ match = { initial_class = "org.telegram.desktop", initial_title = "Save Image" },   float = true, center = true, size = { 750, 550 } })

-- Chatterino
hl.window_rule({ match = { class = "com.chatterino.chatterino" }, float = true, size = { 390, 610 }, move = { 1970, 390 } })

-- jimakuChan Translation
hl.window_rule({ match = { initial_title = ".*jimakuChan.*" }, float = true, size = { 935, 296 }, move = { 2895, 46 } })

