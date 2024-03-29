local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
local mat_list_item = require('widget.material.list-item')
local mat_icon = require('widget.material.icon')
local dpi = require('beautiful').xresources.apply_dpi
local icons = require('theme.icons')

return function(_, panel)
  local search_button =
    wibox.widget {
    wibox.widget {
      icon = icons.search,
      size = dpi(24),
      widget = mat_icon
    },
    wibox.widget {
      text = 'Choose Weapon',
      height = dpi(24),
      font = beautiful.font,
      widget = wibox.widget.textbox
    },
    clickable = true,
    widget = mat_list_item
  }

  search_button:buttons(
    awful.util.table.join(
      awful.button(
        {},
        1,
        function()
          panel:run_rofi()
        end
      )
    )
  )

  local exit_button =
    wibox.widget {
    wibox.widget {
      icon = icons.logout,
      size = dpi(24),
      widget = mat_icon
    },
    wibox.widget {
      text = 'Take a break',
      font = beautiful.font,
      widget = wibox.widget.textbox
    },
    clickable = true,
    divider = true,
    widget = mat_list_item
  }

  exit_button:buttons(
    awful.util.table.join(
      awful.button(
        {},
        1,
        function()
          panel:toggle()
          _G.exit_screen_show()
        end
      )
    )
  )

  return wibox.widget {
    layout = wibox.layout.align.vertical,
    {
      layout = wibox.layout.fixed.vertical,
      {
        search_button,
        bg = beautiful.background.hue_500,
        widget = wibox.container.background
      },
      wibox.widget {
        orientation = 'horizontal',
        forced_height = 1,
        opacity = 0.08,
        widget = wibox.widget.separator
      },
      require('panel.left-panel.dashboard.quick-settings'),
      require('panel.left-panel.dashboard.hardware-monitor'),
    },
    nil,
    {
      layout = wibox.layout.fixed.vertical,
      {
        exit_button,
        bg = beautiful.background.hue_500,
        widget = wibox.container.background
      }
    }
  }
end
