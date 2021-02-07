local awful = require('awful')
require('awful.autofocus')
local modkey = require('configuration.keys.mod').modKey
local altkey = require('configuration.keys.mod').altKey
local naughty = require('naughty')

local clientKeys =
  awful.util.table.join(
  awful.key(
    {modkey},
    'f',
    function(c)
      c.fullscreen = not c.fullscreen
      c:raise()
    end,
    {description = 'toggle fullscreen', group = 'client'}
  ),
  awful.key(
    {modkey, 'Shift'},
    'q',
    function(c)
      c:kill()
    end,
    {description = 'close', group = 'client'}
  ),
  awful.key(
    {modkey},
    'a',
    function(c)
      c.floating = not c.floating
      c.ontop = true
      c.above = true
      naughty.notify({ title = "Floating Status", text = tostring(c.floating)  })
    end
  ),
  awful.key(
    {modkey},
    'm',
    function (c)
      c.maximized_horizontal = not c.maximized_horizontal
      c.maximized_vertical = not c.maximized_vertical
      c.maximized = not c.maximized
      naughty.notify({title = "Maximized", text = tostring(c.maximized)})
    end
  )
)

return clientKeys
