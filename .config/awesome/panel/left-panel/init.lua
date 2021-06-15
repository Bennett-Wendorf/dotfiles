local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
local apps = require('configuration.apps')
local dpi = require('beautiful').xresources.apply_dpi

local left_panel = function(screen)
  local action_bar_width = dpi(41)
  local panel_content_width = dpi(400)

  local panel =
    wibox {
    screen = screen,
    width = action_bar_width,
    height = screen.geometry.height,
    x = screen.geometry.x,
    y = screen.geometry.y,
    ontop = true,
    bg = beautiful.background.hue_800,
    fg = beautiful.fg_normal
  }

  panel.opened = false

  panel:struts(
    {
      left = action_bar_width
    }
  )

  local backdrop =
    wibox {
    ontop = true,
    screen = screen,
    bg = '#00000000',
    type = 'dock',
    x = screen.geometry.x,
    y = screen.geometry.y,
    width = screen.geometry.width,
    height = screen.geometry.height
  }

  function panel:run_rofi()
    _G.awesome.spawn(
      apps.default.rofi,
      false,
      false,
      false,
      false,
      function()
        panel:toggle()
      end
    )
  end

  function panel:run_calc()
    _G.awesome.spawn(
      apps.default.calc,
      false,
      false,
      false,
      false,
      function()
        panel:toggle()
      end
    )
  end

  function panel:run_clipboard()
    _G.awesome.spawn(
      apps.default.clipboard_manager,
      false,
      false,
      false,
      false,
      function()
        panel:toggle()
      end
    )
  end

  -- local openPanel = function(should_run_rofi)
  --   panel.width = action_bar_width + panel_content_width
  --   backdrop.visible = true
  --   panel.visible = false
  --   panel.visible = true
  --   panel:get_children_by_id('panel_content')[1].visible = true
  --   if should_run_rofi then
  --     panel:run_rofi()
  --   end
  --   panel:emit_signal('opened')
  -- end

  -- This command should be an empty string "", "rofi", "clipboard", or "="
  local openPanel = function(command)
    panel.width = action_bar_width + panel_content_width
    backdrop.visible = true
    panel.visible = false
    panel.visible = true
    panel:get_children_by_id('panel_content')[1].visible = true
    if command == "rofi" then
      panel:run_rofi()
    elseif command == "=" then
      panel:run_calc()
    elseif command == "clipboard" then
      panel:run_clipboard()
    end
    panel:emit_signal('opened')
  end

  local closePanel = function()
    panel.width = action_bar_width
    panel:get_children_by_id('panel_content')[1].visible = false
    backdrop.visible = false
    panel:emit_signal('closed')
  end

  -- function panel:toggle(should_run_rofi)
  --   self.opened = not self.opened
  --   if self.opened then
  --     openPanel(should_run_rofi)
  --   else
  --     closePanel()
  --   end
  -- end

  -- This command should be "rofi", "=", "clipboard", or left out entirely for just the panel
  function panel:toggle(command)
    self.opened = not self.opened
    if self.opened then
      openPanel(command)
    else
      closePanel()
    end
  end

  backdrop:buttons(
    awful.util.table.join(
      awful.button(
        {},
        1,
        function()
          panel:toggle()
        end
      )
    )
  )

  panel:setup {
    layout = wibox.layout.align.horizontal,
    nil,
    {
      id = 'panel_content',
      bg = beautiful.background.hue_600,
      widget = wibox.container.background,
      visible = false,
      forced_width = panel_content_width,
      {
        require('panel.left-panel.dashboard')(screen, panel),
        layout = wibox.layout.stack
      }
    },
    require('panel.left-panel.action-bar')(screen, panel, action_bar_width)
  }
  return panel
end

return left_panel
