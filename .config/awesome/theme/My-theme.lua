local filesystem = require('gears.filesystem')
local mat_colors = require('theme.mat-colors')
local theme_dir = filesystem.get_configuration_dir() .. '/theme'
local gears = require('gears')
local dpi = require('beautiful').xresources.apply_dpi
local xresources = require('beautiful.xresources').get_current_theme()
local theme = {}
theme.icons = theme_dir .. '/icons/'
theme.font = 'Jetbrains Mono 10'
-- local wallpaper = '/files/Pics/jonatan-pie-3l3RwQdHRHg-unsplash.jpg'
local wallpaper = '/files/Pics/yash-raut-sHXHvPtcdEQ-unsplash.jpg'
local border_width = 3

-- Colors Pallets

-- Primary
theme.primary = mat_colors.cyan
--theme.primary.hue_500 = '#41bdd3'

-- Accent
theme.accent = mat_colors.pink

-- Background
theme.background = mat_colors.bg_color

local awesome_overrides =
  function(theme)
  theme.dir = os.getenv('HOME') .. '/.config/awesome/theme'

  theme.icons = theme.dir .. '/icons/'
  -- theme.wallpaper = os.getenv('HOME') .. wallpaper
  theme.font = 'Hack 13'
  theme.title_font = 'Hack 14'

  theme.fg_normal = mat_colors.white
  --theme.fg_normal = xresources.color7
  
  -- Stuff for JavaCafe01 awedots replication
  theme.xbackground = xresources.background or "#303030"
  theme.xforeground = xresources.foreground or "#ffffff"
  theme.xcolor0 = xresources.color0 or "#303030"
  theme.xcolor1 = xresources.color1 or "#0E4B71"
  theme.xcolor2 = xresources.color2 or "#348E71"
  theme.xcolor3 = xresources.color3 or "#116397"
  theme.xcolor4 = xresources.color4 or "#165CA5"
  theme.xcolor5 = xresources.color5 or "#258FA2"
  theme.xcolor6 = xresources.color6 or "#4DB0AE"
  theme.xcolor7 = xresources.color7 or "#86c8e0"
  theme.xcolor8 = xresources.color8 or "#5d8c9c"
  theme.xcolor9 = xresources.color9 or "#0E4B71"
  theme.xcolor10 = xresources.color10 or "#348E71"
  theme.xcolor11 = xresources.color11 or "#116397"
  theme.xcolor12 = xresources.color12 or "#165CA5"
  theme.xcolor13 = xresources.color13 or "#258FA2"
  theme.xcolor14 = xresources.color14 or "#4DB0AE"
  theme.xcolor15 = xresources.color15 or "#86c8e0"
  theme.icon_font_name = "FiraCode Nerd Font Mono "

  theme.fg_focus = xresources.color7
  theme.fg_urgent = '#B30000'
  theme.bat_fg_critical = '#232323'
  -- theme.bg_normal = theme.background.hue_800
  theme.bg_normal = theme.background.hue_800
  theme.bg_focus = theme.background.hue_800
  theme.bg_urgent = '#3F3F3F'
  theme.bg_systray = theme.background.hue_800

  -- Borders
  theme.border_width = dpi(border_width)
  theme.border_normal = theme.background.hue_800
  theme.border_focus = theme.primary.hue_300
  theme.border_marked = '#CC9393'

  -- Menu
  -- theme.menu_height = dpi(16)
  -- theme.menu_width = dpi(100)

  -- Tooltips
  -- These are the hover menus on things like widgets
  theme.tooltip_bg = theme.background.hue_600
  -- theme.tooltip_border_color = '#232323'
  theme.tooltip_border_width = 0
  theme.tooltip_shape = function(cr, w, h)
   gears.shape.rounded_rect(cr, w, h, dpi(8))
  end

  -- Layout
  theme.layout_max = theme.icons .. 'layouts/arrow-expand-all.png'
  theme.layout_tile = theme.icons .. 'layouts/view-quilt.png'

  -- Taglist
  -- Note that the linear gradient here is for the vertical bar on the side of the tag
  theme.taglist_bg_empty = theme.background.hue_700
  theme.taglist_bg_occupied = 
    'linear:0,0:' ..
    dpi(48) ..
      ',0:0,' ..
        theme.primary.hue_900 ..
          ':0.08,' .. theme.primary.hue_900 .. ':0.08,' .. theme.background.hue_700 .. ':1,' .. theme.background.hue_700
  theme.taglist_bg_urgent =
   'linear:0,0:' ..
   dpi(48) ..
     ',0:0,' ..
       theme.accent.hue_500 ..
         ':0.08,' .. theme.accent.hue_500 .. ':0.08,' .. theme.background.hue_800 .. ':1,' .. theme.background.hue_800
  theme.taglist_bg_focus =
   'linear:0,0:' ..
   dpi(48) ..
     ',0:0,' ..
       theme.primary.hue_500 ..
         ':0.08,' .. theme.primary.hue_500 .. ':0.08,' .. theme.background.hue_800 .. ':1,' .. theme.background.hue_800

  -- Tasklist1
  theme.tasklist_font = 'Jetbrains Mono 9'
  theme.tasklist_bg_normal = theme.background.hue_700
  theme.tasklist_bg_focus =
    'linear:0,0:0,' ..
    dpi(48) ..
      ':0,' ..
        theme.background.hue_700 ..
          ':0.95,' .. theme.background.hue_700 .. ':0.95,' .. theme.fg_normal .. ':1,' .. theme.fg_normal
  theme.tasklist_bg_urgent = theme.primary.hue_800
  theme.tasklist_fg_focus = '#DDDDDD'
  theme.tasklist_fg_urgent = theme.fg_normal
  theme.tasklist_fg_normal = '#AAAAAA'

  --theme.icon_theme = 'Papirus-Dark'
  theme.icon_theme = 'Abyss-DEEP-Suru-Glow'

  --Client
  theme.border_width = dpi(border_width)
  theme.border_focus = theme.primary.hue_500
  theme.border_normal = theme.background.hue_800
end
return {
  theme = theme,
  awesome_overrides = awesome_overrides
}
