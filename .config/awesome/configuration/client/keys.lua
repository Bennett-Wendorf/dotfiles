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
      if(c.maximized) then
	c.maximized_horizontal = false
      	c.maximized_vertical = false
      	c.maximized = false
      	naughty.notify({title = "Maximized", text = tostring(c.maximized)})
      else
	c.maximized_horizontal = true
	c.maximized_vertical = true
	c.maximized = true
	naughty.notify({title = "Maximized", text = tostring(c.maximized)})
      end
    end
  )
)

return clientKeys
