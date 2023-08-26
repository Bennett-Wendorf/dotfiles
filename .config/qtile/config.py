#region LICENSE

#  ██      ██  ██████ ███████ ███    ██ ███████ ███████ 
#  ██      ██ ██      ██      ████   ██ ██      ██      
#  ██      ██ ██      █████   ██ ██  ██ ███████ █████   
#  ██      ██ ██      ██      ██  ██ ██      ██ ██      
#  ███████ ██  ██████ ███████ ██   ████ ███████ ███████

# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#endregion

#region IMPORTS

#  ██ ███    ███ ██████   ██████  ██████  ████████ ███████ 
#  ██ ████  ████ ██   ██ ██    ██ ██   ██    ██    ██      
#  ██ ██ ████ ██ ██████  ██    ██ ██████     ██    ███████ 
#  ██ ██  ██  ██ ██      ██    ██ ██   ██    ██         ██ 
#  ██ ██      ██ ██       ██████  ██   ██    ██    ███████

import os
import re
import socket
import subprocess
import requests
from libqtile.config import Drag, Key, Screen, Group, Drag, Click, Rule, Match
from libqtile.command import lazy
from libqtile import layout, bar, widget, hook
from libqtile.widget import Spacer
from libqtile.log_utils import logger
from libqtile import qtile
from libqtile import hook

from spawn_default_app import spawn_default_app
import ibattery
#endregion

#region OPTIONS

#   ██████  ██████  ████████ ██  ██████  ███    ██ ███████ 
#  ██    ██ ██   ██    ██    ██ ██    ██ ████   ██ ██      
#  ██    ██ ██████     ██    ██ ██    ██ ██ ██  ██ ███████ 
#  ██    ██ ██         ██    ██ ██    ██ ██  ██ ██      ██ 
#   ██████  ██         ██    ██  ██████  ██   ████ ███████

#mod4 or mod = super key
mod_primary = "mod4"
mod_secondary = "shift"
mod_tertiary = "control"
mod_quaternary = "mod1" # This is alt on most systems

# Used as the home location for some scripts
home = os.path.expanduser('~')
eww_scripts_dir = f"{home}/.config/eww/scripts"
global_scripts_dir = f"{home}/scripts"

# ROFI THEMES
rofi_run_launcher_theme = f"{home}/.config/rofi/launchers/colorful/style_1.rasi"
rofi_util_theme = f"{home}/.config/rofi/launchers/colorful/style_13.rasi"

terminal = "terminator"
run_launcher = f"rofi -show drun -theme '{rofi_run_launcher_theme}'"

# This prevents flameshot from scaling in a weird way if the QT_SCALE_FACTOR is set globally
flameshot_env_modifiers = 'env QT_SCALE_FACTOR=""'

try:
    res = requests.get('https://ipinfo.io/loc', timeout = 1)
    lat, lon = res.text[:-2].split(',')
except requests.exceptions.ConnectionError:
    print("No internet connection")
    lat, lon = None, None
except requests.exceptions.Timeout:
    print("Request timed out")
    lat, lon = None, None
except:
    print("Unknown error")
    lat, lon = None, None
#endregion

# region COLORS
#   ██████  ██████  ██       ██████  ██████  ███████ 
#  ██      ██    ██ ██      ██    ██ ██   ██ ██      
#  ██      ██    ██ ██      ██    ██ ██████  ███████ 
#  ██      ██    ██ ██      ██    ██ ██   ██      ██ 
#   ██████  ██████  ███████  ██████  ██   ██ ███████ 

blue_grey_theme = {
    'bg_color': "#303030",
    'bg_color_alt': "#262626",
    'fg_color': "#c0c5ce",
    'fg_color_alt': "#f3f4f5",
    'fg_dark': "#7d889b",
    'fg_crit': "#cd1f3f",
    'highlight_color': "#4dd0e1",
    'border_focus': "#4dd0e1",
    'border_normal': "#303030",
}

one_dark_theme = {
    'bg_color': "#2a323d",
    'bg_color_alt': "#1f262d",
    'fg_color': "#5c6370",
    'fg_color_alt': "#abb2bf",
    'fg_dark': "#116397",
    'fg_crit': "#e06c75",
    'highlight_color': "#61afef",
    'border_focus': "#61afef",
    'border_normal': "#1e2127"
}

colors = one_dark_theme
#endregion

#region FUNCTIONS

#  ███████ ██    ██ ███    ██  ██████ ████████ ██  ██████  ███    ██ ███████ 
#  ██      ██    ██ ████   ██ ██         ██    ██ ██    ██ ████   ██ ██      
#  █████   ██    ██ ██ ██  ██ ██         ██    ██ ██    ██ ██ ██  ██ ███████ 
#  ██      ██    ██ ██  ██ ██ ██         ██    ██ ██    ██ ██  ██ ██      ██ 
#  ██       ██████  ██   ████  ██████    ██    ██  ██████  ██   ████ ███████ 

@lazy.function
def float_to_front(qtile):
    for group in qtile.groups:
        for window in group.windows:
            if window.floating:
                window.cmd_bring_to_front()

@hook.subscribe.screens_reconfigured
def restart_on_randr(qtile):
    qtile.cmd_restart()

@hook.subscribe.startup_once
def start_once():
    # Set the cursor to something sane in X
    subprocess.Popen(['xsetroot', '-cursor_name', 'left_ptr'])

@hook.subscribe.startup
def start_always():
    subprocess.call([f"{home}/.config/qtile/scripts/autostart.sh"])
#endregion

#region KEYBINDS
#  ██   ██ ███████ ██    ██ ██████  ██ ███    ██ ██████  ███████ 
#  ██  ██  ██       ██  ██  ██   ██ ██ ████   ██ ██   ██ ██      
#  █████   █████     ████   ██████  ██ ██ ██  ██ ██   ██ ███████ 
#  ██  ██  ██         ██    ██   ██ ██ ██  ██ ██ ██   ██      ██ 
#  ██   ██ ███████    ██    ██████  ██ ██   ████ ██████  ███████

keys = [

# WINDOW CONTROLS
    Key([mod_primary, mod_secondary], "q", lazy.window.kill(), desc="Kill current window"),
    Key([mod_primary], "f", lazy.window.toggle_fullscreen(), desc="Toggle the fullscreen status of the current window"),
    Key([mod_primary], "a", lazy.window.toggle_floating(), desc="Toggle floating status of the current window"),
    Key([mod_primary], "m", float_to_front, desc="Bring all floating windows from the current group to the front"),

# WORKSPACES
    Key([mod_primary], "Tab", lazy.screen.next_group(), desc="Go to next workspace"),
    Key([mod_primary, mod_secondary ], "Tab", lazy.screen.prev_group(), desc="Go to previous workspace"),

# QTILE FUNCTIONS
    Key([mod_primary, mod_secondary], "r", lazy.restart(), desc="Restart Qtile"),

    Key([mod_primary, mod_secondary],"e", lazy.spawn(f"{home}/.config/rofi/applets/menu/powermenu.sh"), desc="Launch exit menu"),
    Key([mod_primary], "l", lazy.spawn(f"{home}/.config/i3lock/i3lock.sh"), desc="Lock the screen with i3lock-color"),

# QTILE LAYOUT KEYS
    Key([mod_primary], "r", lazy.layout.reset(), desc="Reset the layout"),
    Key([mod_primary], "space", lazy.next_layout(), desc="Change the layout to the next option"),
    Key([mod_primary, mod_secondary], "space", lazy.prev_layout(), desc="Change the layout to the previous option"),

# CHANGE FOCUS
    Key([mod_primary], "Up", lazy.layout.up(), desc="Change focus up"),
    Key([mod_primary], "Down", lazy.layout.down(), desc="Change focus down"),
    Key([mod_primary], "Left", lazy.layout.left(), desc="Change focus left"),
    Key([mod_primary], "Right", lazy.layout.right(), desc="Change focus right"),

# CHANGE SCREEN FOCUS
    Key([mod_primary], "o", lazy.next_screen(), desc="Change focus to the next monitor"),
    Key([mod_primary, mod_secondary], "o", lazy.prev_screen(), desc="Change focus to the previous monitor"),

# RESIZE UP, DOWN, LEFT, RIGHT
    Key([mod_primary, mod_tertiary], "l",
        lazy.layout.grow_right(),
        lazy.layout.grow(),
        lazy.layout.increase_ratio(),
        lazy.layout.delete(),
        desc="Grow right"),
    Key([mod_primary, mod_tertiary], "Right",
        lazy.layout.grow_right(),
        lazy.layout.grow(),
        lazy.layout.increase_ratio(),
        lazy.layout.delete(),
        desc="Grow right"),
    Key([mod_primary, mod_tertiary], "h",
        lazy.layout.grow_left(),
        lazy.layout.shrink(),
        lazy.layout.decrease_ratio(),
        lazy.layout.add(),
        desc="Grow left"),
    Key([mod_primary, mod_tertiary], "Left",
        lazy.layout.grow_left(),
        lazy.layout.shrink(),
        lazy.layout.decrease_ratio(),
        lazy.layout.add(),
        desc="Grow left"),
    Key([mod_primary, mod_tertiary], "k",
        lazy.layout.grow_up(),
        lazy.layout.grow(),
        lazy.layout.decrease_nmaster(),
        desc="Grow up"),
    Key([mod_primary, mod_tertiary], "Up",
        lazy.layout.grow_up(),
        lazy.layout.grow(),
        lazy.layout.decrease_nmaster(),
        desc="Grow up"),
    Key([mod_primary, mod_tertiary], "j",
        lazy.layout.grow_down(),
        lazy.layout.shrink(),
        lazy.layout.increase_nmaster(),
        desc="Grow down"),
    Key([mod_primary, mod_tertiary], "Down",
        lazy.layout.grow_down(),
        lazy.layout.shrink(),
        lazy.layout.increase_nmaster(),
        desc="Grow down"),


# FLIP LAYOUT FOR MONADTALL/MONADWIDE
    Key([mod_primary, mod_secondary], "f", lazy.layout.flip(), desc="Flip layout for Monadtall and Monadwide"),

# FLIP LAYOUT FOR BSP
    Key([mod_primary, mod_quaternary], "Up", lazy.layout.flip_up(), desc="Flip layout up for BSP"),
    Key([mod_primary, mod_quaternary], "Down", lazy.layout.flip_down(), desc="Flip layout down for BSP"),
    Key([mod_primary, mod_quaternary], "Left", lazy.layout.flip_right(), desc="Flip layout right for BSP"),
    Key([mod_primary, mod_quaternary], "Right", lazy.layout.flip_left(), desc="Flip layout left for BSP"),

# MOVE WINDOWS UP OR DOWN BSP OR MODAD LAYOUTS
    Key([mod_primary, mod_secondary], "Up", lazy.layout.shuffle_up(), desc="Move window up"),
    Key([mod_primary, mod_secondary], "Down", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod_primary, mod_secondary], "Left", lazy.layout.shuffle_left(), lazy.layout.swap_left(), desc="Move window left"),
    Key([mod_primary, mod_secondary], "Right", lazy.layout.shuffle_right(), lazy.layout.swap_right(), desc="Move window right"),

# APPLICATIONS
    Key([mod_primary], "Return", lazy.spawn(terminal), desc="Spawn a terminal"),
    Key([mod_primary], "d", lazy.spawn(run_launcher), desc="Spawn run launcher"),

# SCREENSHOT
    Key([mod_primary, mod_tertiary], "c", lazy.spawn(f"{flameshot_env_modifiers} flameshot screen -c -d 5000"), desc="Wait 5 seconds and take a screenshot"),
    Key([mod_primary], "c", lazy.spawn(f"{flameshot_env_modifiers} flameshot screen -c"), desc="Take a screenshot"),
    Key([mod_primary, mod_secondary], "c", lazy.spawn(f"{flameshot_env_modifiers} flameshot gui"), desc="Mark an area and screenshot it"),
    Key([], "Print", lazy.spawn(f"{flameshot_env_modifiers} flameshot screen -c"), desc="Take a screenshot"),
    Key([mod_secondary], "Print", lazy.spawn(f"{flameshot_env_modifiers} flameshot gui"), desc="Mark an area and screenshot it"),

# MUlTIMEDIA
    Key([], "XF86AudioPlay", lazy.spawn("playerctl play-pause"), desc="Play or pause audio with playerctl"),
    Key([], "XF86AudioNext", lazy.spawn("playerctl next"), desc="Skip to the next track with playerctl"),
    Key([], "XF86AudioPrev", lazy.spawn("playerctl previous"), desc="Skip to the previous track with playerctl"),
    Key([], "XF86AudioMute", lazy.spawn(f"{eww_scripts_dir}/eww_vol.sh mute"), desc="Mute"),
    Key([], "XF86AudioRaiseVolume", lazy.spawn(f"{eww_scripts_dir}/eww_vol.sh up"), desc="Volume up 5%"),
    Key([], "XF86AudioLowerVolume", lazy.spawn(f"{eww_scripts_dir}/eww_vol.sh down"), desc="Volume down 5%"),
    Key([], "XF86MonBrightnessUp", lazy.spawn(f"{eww_scripts_dir}/eww_bright.sh up"), desc="Increase brightness 10%"),
    Key([], "XF86MonBrightnessDown", lazy.spawn(f"{eww_scripts_dir}/eww_bright.sh down"), desc="Decrease brightness 10%"),


    Key([mod_quaternary], "space", lazy.spawn(f"{eww_scripts_dir}/eww_sidebar.sh"), desc="Toggle sidebar"),
    Key([mod_primary], "v", lazy.spawn(f"rofi -theme '{rofi_util_theme}' -modi 'clipboard:greenclip print' -show clipboard -run-command '{{cmd}}'"), desc="Open clipboard manager"),
    Key([mod_primary], "equal", lazy.spawn(f"= -- -theme '{rofi_util_theme}'"), desc="Run calculator in rofi"),
    Key([mod_tertiary], "m", lazy.spawn("find-cursor -c '#4dd0e1' -f -t -r 2"), desc="Launch the program to find the cursor"),
    Key([mod_primary, mod_secondary], "l", lazy.spawn(f"{global_scripts_dir}/autolock_toggle/autolock_toggle.sh"), desc="Toggle the xidlehook program for autolocking"),

# NOTIFICATIONS
    Key([mod_primary], "n", lazy.spawn(f"{home}/.config/rofi/rofi_notif_center.sh"), desc="Launch the notification center"),
    Key([], "XF86AudioMedia", lazy.spawn(f"{home}/.config/rofi/rofi_notif_center.sh"), desc="Launch the notification center"),
    
    Key([mod_primary], "p" ,lazy.spawn(f"{home}/.config/qtile/scripts/displayselect.sh"), desc="Change display configuration with autorandr"),
]
#endregion

#region GROUPS

#   ██████  ██████   ██████  ██    ██ ██████  ███████ 
#  ██       ██   ██ ██    ██ ██    ██ ██   ██ ██      
#  ██   ███ ██████  ██    ██ ██    ██ ██████  ███████ 
#  ██    ██ ██   ██ ██    ██ ██    ██ ██           ██ 
#   ██████  ██   ██  ██████   ██████  ██      ███████ 

groups = []

group_configs = [
    {"name": "1", "label": "", "layout": "monadtall", "default_app": "firefox"},
    {"name": "2", "label": "", "layout": "monadtall", "default_app": "code"},
    {"name": "3", "label": "", "layout": "monadtall", "default_app": "nemo"},
    {"name": "4", "label": "", "layout": "monadtall", "default_app": None},
    {"name": "5", "label": "", "layout": "monadtall", "default_app": None},
    {"name": "6", "label": "", "layout": "monadtall", "default_app": "firefox"},
    {"name": "7", "label": "", "layout": "monadtall", "default_app": None},
    {"name": "8", "label": "", "layout": "monadtall", "default_app": "discord"},
    {"name": "9", "label": "", "layout": "monadtall", "default_app": "pavucontrol"},
    {"name": "0", "label": "", "layout": "monadtall", "default_app": "terminator -e bpytop"},
]

for config in group_configs:
    group = Group(
            name=config["name"],
            layout=config["layout"].lower(),
            label=config["label"],
        )
    group.default_app = config["default_app"]
    groups.append(group)
#endregion

#region GROUP KEYBINDS

#   ██████  ██████   ██████  ██    ██ ██████      ██   ██ ███████ ██    ██ ██████  ██ ███    ██ ██████  ███████ 
#  ██       ██   ██ ██    ██ ██    ██ ██   ██     ██  ██  ██       ██  ██  ██   ██ ██ ████   ██ ██   ██ ██      
#  ██   ███ ██████  ██    ██ ██    ██ ██████      █████   █████     ████   ██████  ██ ██ ██  ██ ██   ██ ███████ 
#  ██    ██ ██   ██ ██    ██ ██    ██ ██          ██  ██  ██         ██    ██   ██ ██ ██  ██ ██ ██   ██      ██ 
#   ██████  ██   ██  ██████   ██████  ██          ██   ██ ███████    ██    ██████  ██ ██   ████ ██████  ███████ 

keys.extend([
    Key([mod_primary], "t", lazy.function(spawn_default_app, groups, [group["default_app"] for group in group_configs], unset_default_app=run_launcher), desc="Spawn the default app for the current group"),
])

for i in groups:
    keys.extend([
        #CHANGE WORKSPACES
        Key([mod_primary], i.name, lazy.group[i.name].toscreen(toggle=True), desc=f"Go to workspace {i.name}"),

        # MOVE WINDOW TO SELECTED WORKSPACE 1-10 AND STAY ON WORKSPACE
        Key([mod_primary, mod_secondary], i.name, lazy.window.togroup(i.name), desc=f"Move window to workspace {i.name}"),
        # MOVE WINDOW TO SELECTED WORKSPACE 1-10 AND FOLLOW MOVED WINDOW TO WORKSPACE
        Key([mod_primary, mod_secondary, mod_tertiary], i.name, lazy.window.togroup(i.name) , lazy.group[i.name].toscreen(), desc=f"Move window to workspace {i.name} and follow it there"),
    ])

def show_keys():
	key_help = ""
	for k in keys:
		mods = ""

		for m in k.modifiers:
			if m == "mod4":
				mods += "Super + "
			else:
				mods += m.capitalize() + " + "

		if len(k.key) > 1:
			mods += k.key.capitalize()
		else:
			mods += k.key

		key_help += "{:<30} {}".format(mods, k.desc + "\n")

	return key_help

keys.extend([
    Key([mod_primary], "h", lazy.spawn(f"sh -c 'echo \"{show_keys()}\" | rofi -theme \"{rofi_util_theme}\" -dmenu -i -p \"?\"'"), desc="Print keyboard bindings"),
])
#endregion

#region LAYOUTS

#  ██       █████  ██    ██  ██████  ██    ██ ████████ ███████ 
#  ██      ██   ██  ██  ██  ██    ██ ██    ██    ██    ██      
#  ██      ███████   ████   ██    ██ ██    ██    ██    ███████ 
#  ██      ██   ██    ██    ██    ██ ██    ██    ██         ██ 
#  ███████ ██   ██    ██     ██████   ██████     ██    ███████ 
 
layout_theme = {"margin":8,
                "border_width":2,
                "border_focus": colors['border_focus'],
                "border_normal": colors['border_normal']
                }

layouts = [
    layout.MonadTall(**layout_theme),
    layout.MonadWide(**layout_theme),
    layout.Matrix(**layout_theme),
    layout.Bsp(**layout_theme),
    layout.Floating(**layout_theme),
    layout.RatioTile(**layout_theme),
    layout.Max(**layout_theme),
    layout.Zoomy(**layout_theme),
]
#endregion

#region BAR

#  ██████   █████  ██████  
#  ██   ██ ██   ██ ██   ██ 
#  ██████  ███████ ██████  
#  ██   ██ ██   ██ ██   ██ 
#  ██████  ██   ██ ██   ██

widget_defaults = {
    "icon_font": "Font Awesome 6 Free Solid",
    "font": "Hack",
    "fontsize": 22,
    "padding": 2,
    "background": colors['bg_color'],
    "background_alt": colors['bg_color_alt'],
    "foreground": colors['fg_color'],
}

def init_left_widgets_list():
    return [
        widget.Spacer(
            length = 20,
            background = widget_defaults['background_alt'],
        ),
        widget.TextBox(
            font = widget_defaults['icon_font'],
            text = "",
            foreground = colors['highlight_color'],
            background = widget_defaults['background_alt'],
            padding = 5,
            fontsize = widget_defaults['fontsize'],
            mouse_callbacks = {"Button1": lambda : qtile.cmd_spawn(f'{home}/.config/rofi/applets/menu/powermenu.sh')}
        ),
        widget.Spacer(
            length = 10,
            background = widget_defaults['background_alt'],
        ),
        widget.Image(
            filename = f"{home}/.config/qtile/res/slant_left_two_tone.png",
        ),
        widget.GroupBox(
            font = widget_defaults['icon_font'],
            fontsize = widget_defaults['fontsize'],
            margin_y = 2,
            margin_x = 0,
            padding_y = 6,
            padding_x = 8,
            borderwidth = 0,
            disable_drag = True,
            active = colors['fg_dark'],
            inactive = colors['border_normal'],
            highlight_method = "text",
            this_current_screen_border = colors['highlight_color'],
            foreground = widget_defaults['foreground'],
            background = widget_defaults['background'],
        ),
        widget.Image(
            filename = f"{home}/.config/qtile/res/slant_right_two_tone.png",
        ),
        widget.Spacer(
            length = 10,
            background = widget_defaults['background_alt'],
        ),
        widget.CurrentLayoutIcon(
            foreground = widget_defaults['foreground'],
            background = widget_defaults['background_alt'],
            scale = .65,
        ),
        widget.Image(
            filename = f"{home}/.config/qtile/res/slant_right_dark_color.png",
        ),
        widget.Spacer(
            length = 10,
            background = widget_defaults['background_alt'],
        ),
        widget.TextBox(
            font = widget_defaults['icon_font'],
            text = "",
            foreground = colors['highlight_color'],
            background = widget_defaults['background_alt'],
            padding = 5,
            fontsize = widget_defaults['fontsize'],
        ),
        widget.Spacer(
            length = 5,
            background = widget_defaults['background_alt'],
        ),
        widget.CPU(
            foreground = widget_defaults['foreground'],
            background = widget_defaults['background_alt'],
            format = "{freq_current} GHz  {load_percent}%",
        ),
        widget.Image(
            filename = f"{home}/.config/qtile/res/curve_right_two_tone.png",
        ),
        widget.Spacer(),
    ]

def init_right_widgets_list():
    return [
        widget.OpenWeather(
            font = widget_defaults['font'],
            fontsize = widget_defaults['fontsize'],
            background = widget_defaults['background_alt'],
            foreground = widget_defaults['foreground'],
            format = "{location_city}: {icon} {temp:.0f}°{units_temperature}",
            coordinates = {'latitude': lat or '0', 'longitude': lon or '0'},
            metric = False,
            api_key = "4413f6eb74f8618a4f1a2d2570c8cf2d",
        ),
        widget.Image(
            filename = f"{home}/.config/qtile/res/slant_left_two_tone.png",
        ),
        widget.TextBox(
            font = widget_defaults['icon_font'],
            text = "",
            foreground = colors['highlight_color'],
            background = widget_defaults['background'],
            padding = 5,
            fontsize = widget_defaults['fontsize'],
        ),
        widget.Spacer(
            length = 15,
        ),
        # do not activate in Virtualbox - will break qtile
        widget.ThermalSensor(
            foreground = colors['fg_color_alt'],
            foreground_alert = colors['fg_crit'],
            background = widget_defaults['background'],
            metric = True,
            padding = 3,
            threshold = 85,
            format = "{temp:.0f}°C",
            fontsize = widget_defaults['fontsize'],
        ),
        widget.Image(
            filename = f"{home}/.config/qtile/res/slant_left_base_color.png",
        ),
        ibattery.Battery(
            foreground = colors['fg_color_alt'],
            background = widget_defaults['background'],
        ),
        widget.Image(
            filename = f"{home}/.config/qtile/res/curve_left_two_tone.png",
        ),
        widget.Spacer(
            length = 5,
            background = widget_defaults['background_alt'],
        ),
        widget.TextBox(
            font = widget_defaults['icon_font'],
            text = "",
            foreground = colors['highlight_color'],
            background = widget_defaults['background_alt'],
            padding = 5,
            fontsize = widget_defaults['fontsize'],
            mouse_callbacks = { "Button1": lazy.spawn(f"{eww_scripts_dir}/eww_calendar.sh") }
        ),
        widget.Spacer(
            length = 5,
            background = widget_defaults['background_alt'],
        ),
        widget.Clock(
            foreground = colors['fg_color_alt'],
            background = widget_defaults['background_alt'],
            fontsize = widget_defaults['fontsize'],
            format = "%I:%M %P",
            mouse_callbacks = { "Button1": lazy.spawn(f"{eww_scripts_dir}/eww_calendar.sh") }
        ),
        widget.Spacer(
            length=20,
            background=widget_defaults['background_alt']
        ),
    ]

def init_widgets_screen_1():
    widgets_screen_1 = init_left_widgets_list()
    # Append needed systray widgets only to screen 1. I don't want these to show on my second screen
    widgets_screen_1.append(widget.Image(
        filename = f"{home}/.config/qtile/res/curve_left_two_tone.png",
    ))
    widgets_screen_1.append(widget.Systray(
        background = widget_defaults['background_alt'],
        icon_size = 26,
        padding = 6,
    ))
    widgets_screen_1.append(widget.Image(
        filename = f"{home}/.config/qtile/res/slant_right_dark_color.png",
    ))
    widgets_screen_1.extend(init_right_widgets_list())
    return widgets_screen_1

def init_widgets_screen_2():
    widgets_screen_2 = init_left_widgets_list()
    widgets_screen_2.append(widget.Image(
        filename = f"{home}/.config/qtile/res/curve_left_two_tone.png",
    ))
    widgets_screen_2.extend(init_right_widgets_list())
    return widgets_screen_2

screen_config = {
    "margin": [8, 8, 0, 8],
    "size": 40, 
    "opacity": 1,
}

screens = [
    Screen(top=bar.Bar(widgets=init_widgets_screen_1(), **screen_config)),
    Screen(top=bar.Bar(widgets=init_widgets_screen_2(), **screen_config)),
]
#endregion

#region MISC CONFIG

#  ███    ███ ██ ███████  ██████      ██████  ██████  ███    ██ ███████ ██  ██████  
#  ████  ████ ██ ██      ██          ██      ██    ██ ████   ██ ██      ██ ██       
#  ██ ████ ██ ██ ███████ ██          ██      ██    ██ ██ ██  ██ █████   ██ ██   ███ 
#  ██  ██  ██ ██      ██ ██          ██      ██    ██ ██  ██ ██ ██      ██ ██    ██ 
#  ██      ██ ██ ███████  ██████      ██████  ██████  ██   ████ ██      ██  ██████  

# MOUSE CONFIGURATION
mouse = [
    Drag([mod_primary], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod_primary], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod_primary], "Button2", lazy.window.bring_to_front())
]

follow_mouse_focus = True
bring_front_click = True
cursor_warp = False

# Some types of windows to always float on startup
floating_layout = layout.Floating(float_rules=[
    *layout.Floating.default_float_rules,
    Match(wm_class='pinentry'), # GPG key password entry
    Match(wm_class='pinentry-gtk-2'),
    Match(wm_class='ssh-askpass'), # ssh-askpass
    Match(wm_class='MEGAsync'),
    Match(wm_class='Open File'),
    Match(wm_class='xfreerdp'),
    Match(title='flameshot'),
], fullscreen_border_width = 0, border_width = 0)

auto_fullscreen = True

reconfigure_screens = True

focus_on_window_activation = "smart" # or focus

# Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
#endregion