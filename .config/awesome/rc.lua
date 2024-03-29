local gears = require('gears')
local awful = require('awful')
require('awful.autofocus')
local beautiful = require('beautiful')
local naughty = require('naughty')

-- Theme
beautiful.init(require('theme'))

-- Layout
require('panel')

-- Init all modules
require('module.notifications')
require('module.decorate-client')
require('module.exit-screen')

local bling = require("module.bling")
--bling.signal.playerctl.enable {
--  ignore = {},
--  backend = "playerctl_lib",
--  update_on_activity = true
--}

-- Setup all configurations
require('configuration.client')
require('configuration.tags')
_G.root.keys(require('configuration.keys.global'))

-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(
  function(s)
    -- If wallpaper is a function, call it with the screen
    if beautiful.wallpaper then
        if type(beautiful.wallpaper) == "string" then
            if beautiful.wallpaper:sub(1, #"#") == "#" then
                gears.wallpaper.set(beautiful.wallpaper)
            elseif beautiful.wallpaper:sub(1, #"/") == "/" then
                gears.wallpaper.maximized(beautiful.wallpaper, s)
            end
        else
            beautiful.wallpaper(s)
        end
    end
  end
)

-- Signal function to execute when a new client appears.
_G.client.connect_signal(
  'manage',
  function(c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    if not _G.awesome.startup then
      awful.client.setslave(c)
    end

    if _G.awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
      -- Prevent clients from being unreachable after screen count changes.
      awful.placement.no_offscreen(c)
    end
  end
)

-- Enable sloppy focus, so that focus follows mouse.
_G.client.connect_signal(
  'mouse::enter',
  function(c)
    c:emit_signal('request::activate', 'mouse_enter', {raise = true})
  end
)

-- Make the focused window have a glowing border
_G.client.connect_signal(
  'focus',
  function(c)
    c.border_color = beautiful.border_focus
  end
)
_G.client.connect_signal(
  'unfocus',
  function(c)
    c.border_color = beautiful.border_normal
  end
)

-- Autostart apps should happen after everything else
-- This ensures that a system tray as well as any other required resources are available
require('module.auto-start')
