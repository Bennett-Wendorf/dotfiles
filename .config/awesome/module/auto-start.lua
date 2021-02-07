-- MODULE AUTO-START
-- Run all the apps listed in configuration/apps.lua as run_on_start_up only once when awesome start

local awful = require('awful')
local apps = require('configuration.apps')

local function run_once(cmd)
  local findme = cmd
  local firstspace = cmd:find(' ')
  if firstspace then
    findme = cmd:sub(0, firstspace - 1)
  end
  awful.spawn.with_shell(string.format('pgrep -u $USER -x %s > /dev/null || (%s)', findme, cmd))
end

--[[for _, app in ipairs(apps.run_on_start_up) do
  run_once(app)
end--]]

for _,i in pairs(apps.run_on_start_up) do
	awful.util.spawn(i)
end

-- This will delay the startup of the delayed_start_apps to ensure the system tray exists
-- I'm not sure why, but it seems to only work with a 0 second delay.
delay_amount = 0
os.execute('sleep ' .. tonumber(delay_amount))

for _,i in pairs(apps.delayed_start_up) do
	awful.util.spawn(i)
end
