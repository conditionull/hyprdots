local M = {}

M.twitch_name = "ohnepixel"
M.twitch_uuid = "6767676767676767676767"

return M



-- to access these values in hyprland.lua, you can do the following:
-- local ok, private = pcall(require, "private")
-- if not ok then
--   private = {}
-- end

-- then for example:
-- hl.bind(
--     mainMod .. " + SHIFT + T",
--     hl.dsp.exec_cmd(
--         'bash -c "source ~/.config/hypr/env.sh; firefox --new-window \'https://dashboard.twitch.tv/popout/u/'
--         .. private.twitch_name .. '/stream-manager/activity-feed?uuid=' .. private.twitch_uuid .. '\'"'
--     )
-- )

