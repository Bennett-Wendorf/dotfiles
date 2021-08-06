local awful = require('awful')
local gears = require('gears')
local icons = require('theme.icons')
local apps = require('configuration.apps')
local sharedtags = require('module.awesome-sharedtags')

local tags = {
  {
    icon = icons.firefox,
    type = 'firefox',
    defaultApp = apps.default.browser,
    -- screen = 1
  },
  {
    icon = icons.code,
    type = 'code',
    defaultApp = apps.default.editor,
    -- screen = 1
  },
  {
    icon = icons.folder,
    type = 'folder',
    defaultApp = apps.default.files,
    -- screen = 1
  },
  {
    icon = icons.vm,
    type = 'vm',
    defaultApp = apps.default.rofi,
    -- screen = 1
  },
  {
    icon = icons.lab,
    type = 'any',
    defaultApp = apps.default.rofi,
    -- screen = 1
  },
  {
    icon = icons.game,
    type = 'game',
    defaultApp = apps.default.game,
    -- screen = 1
  },
  {
    icon = icons.social_forum,
    type = 'social_forum',
    defaultApp = apps.default.social,
    -- screen = 1
  },
  {
    icon = icons.music,
    type = 'music',
    defaultApp = apps.default.music,
    -- screen = 1
  },
  {
    icon = icons.debug,
    type = 'debug',
    defaultApp = apps.default.debug,
    -- screen = 1
  }
}

awful.layout.layouts = {
  awful.layout.suit.spiral.dwindle,
  awful.layout.suit.floating,
  awful.layout.suit.tile,
  awful.layout.suit.max,
}

awful.screen.connect_for_each_screen(
  function(s)
    for i, tag in pairs(tags) do
      awful.tag.add(
        i,
        {
          icon = tag.icon,
          icon_only = true,
          layout = awful.layout.layouts[3],
          gap_single_client = true,
          gap = 4,
          screen = s,
          defaultApp = tag.defaultApp,
          selected = i == 1
        }
      )
    end
  end
)

_G.tag.connect_signal(
  'property::layout',
  function(t)
    local currentLayout = awful.tag.getproperty(t, 'layout')
    if (currentLayout == awful.layout.suit.max) then
      t.gap = 6
    else
      t.gap = 6
    end
  end
)
