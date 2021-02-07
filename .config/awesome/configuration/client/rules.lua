local awful = require('awful')
local gears = require('gears')
local client_keys = require('configuration.client.keys')
local client_buttons = require('configuration.client.mouse_buttons')
local beautiful = require('beautiful')

-- Rules
awful.rules.rules = {
  -- All clients will match this rule.
  {
    rule = {},
    properties = {
      focus = awful.client.focus.filter,
      raise = true,
      keys = client_keys,
      buttons = client_buttons,
      screen = awful.screen.preferred,
      placement = awful.placement.no_offscreen,
    },
    -- Forces all applications to start not maximized
    -- This seemed to fix an issue where some applications start maximized and are unable to pull out of it.
    callback = function(c)
    	    c.maximized, c.maximized_vertical, c.maximized_horizontal = false, false, false
    end,
  },
  {
    rule_any = {name = {'QuakeTerminal'}},
    properties = {skip_decoration = true}
  },
  -- Floating Clients
  { rule_any = {
        instance = {
          "copyq",  -- Includes session name in class.
        },
        class = {
          "megasync",
          "Protonvpn-gui",
  	},
        name = {
          "Event Tester",  -- xev.
	        "MEGAsync",
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, 
      properties = { 
	      floating = true, 
	      above = true,
	      ontop = true,
	      drawBackdrop = true,
	      placement = awful.placement.centered,
      }
  },

  { rule_any = {
	class = {
	  "Org.gnome.Nautilus",
	  "Gnome-boxes"
	}
    },
    properties = {
	
    }      
  },

  -- Titlebars
  {
    rule_any = {type = {'dialog'}, class = {'Wicd-client.py', 'calendar.google.com'}},
    properties = {
      placement = awful.placement.centered,
      ontop = true,
      floating = true,
      drawBackdrop = true,
      shape = function()
        return function(cr, w, h)
          gears.shape.rounded_rect(cr, w, h, 0)
        end
      end,
      skip_decoration = false
    }
  }
}
