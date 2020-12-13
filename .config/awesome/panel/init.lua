local awful = require('awful')
local left_panel = require('panel.left-panel')
local top_panel = require('panel.top-panel')
local use_top_panel = false

-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(
  function(s)
    --[[if s.index == 1 then
      -- Create the left_panel
      s.left_panel = left_panel(s)
      -- Create the Top bar
      s.top_panel = top_panel(s, false)
   else
       -- Create the Top bar
      s.top_panel = top_panel(s, false)
    end--]]
    -- Create the left_panel
    s.left_panel = left_panel(s)
    -- Create the Top Bar
    if use_top_panel then
    	s.top_panel = top_panel(s, false)
    end
  end
)

-- Hide bars when app go fullscreen
function updateBarsVisibility()
  for s in screen do
    if s.selected_tag then
      local fullscreen = s.selected_tag.fullscreenMode
      -- Order matter here for shadow
      if use_top_panel then
      	s.top_panel.visible = not fullscreen
      end
      if s.left_panel then
        s.left_panel.visible = not fullscreen
      end
    end
  end
end

_G.tag.connect_signal(
  'property::selected',
  function(t)
    updateBarsVisibility()
  end
)

_G.client.connect_signal(
  'property::fullscreen',
  function(c)
    c.screen.selected_tag.fullscreenMode = c.fullscreen
    updateBarsVisibility()
  end
)

_G.client.connect_signal(
  'unmanage',
  function(c)
    if c.fullscreen then
      c.screen.selected_tag.fullscreenMode = false
      updateBarsVisibility()
    end
  end
)
