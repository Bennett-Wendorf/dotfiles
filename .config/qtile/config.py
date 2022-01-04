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

import os
import re
import socket
import subprocess
from libqtile.config import Drag, Key, Screen, Group, Drag, Click, Rule, Match
from libqtile.command import lazy
from libqtile import layout, bar, widget, hook
from libqtile.widget import Spacer
import arcobattery
from libqtile.log_utils import logger
from libqtile import qtile

#mod4 or mod = super key
mod = "mod4"
mod1 = "alt"
mod2 = "control"
home = os.path.expanduser('~')
terminal = "terminator"
# run_launcher = "dmenu_run -i -fn 'Hack-10' -nb '#2E3440' -nf '#88C0D0' -sb '#88C0D0' -sf '#2E3440'"
run_launcher = "rofi -show drun -theme '~/.config/rofi/launchers/colorful/style_1.rasi'"

# COLORS
colors = {
    # 'bg_color': "#2F343F",
    'bg_color': "#303030",
    'fg_color': "#c0c5ce",
    'fg_color_alt': "#f3f4f5",
    'fg_crit': "#cd1f3f",
    'highlight_color': "#4dd0e1",
    'border_focus': "#4dd0e1",
    'border_normal': "#303030",
}

@lazy.function
def window_to_prev_group(qtile):
    if qtile.currentWindow is not None:
        i = qtile.groups.index(qtile.currentGroup)
        qtile.currentWindow.togroup(qtile.groups[i - 1].name)

@lazy.function
def window_to_next_group(qtile):
    if qtile.currentWindow is not None:
        i = qtile.groups.index(qtile.currentGroup)
        qtile.currentWindow.togroup(qtile.groups[i + 1].name)

def getIndex(currentGroupName):
    if groups:
        for i in range(len(groups)):
            if groups[i].name == currentGroupName:
                return i
    else:
        return None

# Spawn the default app for this group
def spawn_default_app(qtile):
    groupIndex = getIndex(qtile.current_group.name)
    if qtile.current_group is not None and groupIndex is not None:
        app = groups[groupIndex].default_app
        qtile.cmd_spawn(app)
    elif qtile.current_group is not None and groupIndex is None:
        qtile.cmd_spawn(run_launcher)

def float_to_front(qtile):
    """Bring all floating windows of the group to front"""
    for window in qtile.currentGroup.windows:
        if window.floating:
            window.cmd_bring_to_front()

keys = [

# WINDOW CONTROLS
    Key([mod, "shift"], "q", lazy.window.kill(), desc="Kill current window"),
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc="Toggle the fullscreen status of the current window"),
    Key([mod], "a", lazy.window.toggle_floating(), desc="Toggle floating status of the current window"),
    Key([mod], "m", lazy.function(float_to_front), desc="Bring all floating windows from the current group to the front"),

# WORKSPACES
    Key([mod], "Tab", lazy.screen.next_group(), desc="Go to next workspace"),
    Key([mod, "shift" ], "Tab", lazy.screen.prev_group(), desc="Go to previous workspace"),

# QTILE FUNCTIONS
    Key([mod, "shift"], "r", lazy.restart(), desc="Restart Qtile"),
    Key([mod, "shift"],"e", lazy.spawn("./.config/rofi/applets/menu/powermenu.sh"), desc="Launch exit menu"),
    Key([mod], "l", lazy.spawn("./.config/i3lock/i3lock.sh"), desc="Lock the screen with i3lock-color"),

# QTILE LAYOUT KEYS
    Key([mod], "r", lazy.layout.reset(), desc="Reset the layout"),
    Key([mod], "space", lazy.next_layout(), desc="Change the layout to the next option"),
    Key([mod, "shift"], "space", lazy.prev_layout(), desc="Change the layout to the previous option"),

# CHANGE FOCUS
    Key([mod], "Up", lazy.layout.up(), desc="Change focus up"),
    Key([mod], "Down", lazy.layout.down(), desc="Change focus down"),
    Key([mod], "Left", lazy.layout.left(), desc="Change focus left"),
    Key([mod], "Right", lazy.layout.right(), desc="Change focus right"),

# CHANGE SCREEN FOCUS
    Key([mod], "o", lazy.next_screen(), desc="Next monitor"),

# RESIZE UP, DOWN, LEFT, RIGHT
    Key([mod, "control"], "l",
        lazy.layout.grow_right(),
        lazy.layout.grow(),
        lazy.layout.increase_ratio(),
        lazy.layout.delete(),
        desc="Grow right"),
    Key([mod, "control"], "Right",
        lazy.layout.grow_right(),
        lazy.layout.grow(),
        lazy.layout.increase_ratio(),
        lazy.layout.delete(),
        desc="Grow right"),
    Key([mod, "control"], "h",
        lazy.layout.grow_left(),
        lazy.layout.shrink(),
        lazy.layout.decrease_ratio(),
        lazy.layout.add(),
        desc="Grow left"),
    Key([mod, "control"], "Left",
        lazy.layout.grow_left(),
        lazy.layout.shrink(),
        lazy.layout.decrease_ratio(),
        lazy.layout.add(),
        desc="Grow left"),
    Key([mod, "control"], "k",
        lazy.layout.grow_up(),
        lazy.layout.grow(),
        lazy.layout.decrease_nmaster(),
        desc="Grow up"),
    Key([mod, "control"], "Up",
        lazy.layout.grow_up(),
        lazy.layout.grow(),
        lazy.layout.decrease_nmaster(),
        desc="Grow up"),
    Key([mod, "control"], "j",
        lazy.layout.grow_down(),
        lazy.layout.shrink(),
        lazy.layout.increase_nmaster(),
        desc="Grow down"),
    Key([mod, "control"], "Down",
        lazy.layout.grow_down(),
        lazy.layout.shrink(),
        lazy.layout.increase_nmaster(),
        desc="Grow down"),


# FLIP LAYOUT FOR MONADTALL/MONADWIDE
    Key([mod, "shift"], "f", lazy.layout.flip(), desc="Flip layout for Monadtall and Monadwide"),

# FLIP LAYOUT FOR BSP
    Key([mod, "mod1"], "k", lazy.layout.flip_up(), desc="Flip layout up for BSP"),
    Key([mod, "mod1"], "j", lazy.layout.flip_down(), desc="Flip layout down for BSP"),
    Key([mod, "mod1"], "l", lazy.layout.flip_right(), desc="Flip layout right for BSP"),
    Key([mod, "mod1"], "h", lazy.layout.flip_left(), desc="Flip layout left for BSP"),

# MOVE WINDOWS UP OR DOWN BSP LAYOUT
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window right"),

# MOVE WINDOWS UP OR DOWN MONADTALL/MONADWIDE LAYOUT
    Key([mod, "shift"], "Up", lazy.layout.shuffle_up(), desc="Move window up"),
    Key([mod, "shift"], "Down", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "Left", lazy.layout.swap_left(), desc="Move window left"),
    Key([mod, "shift"], "Right", lazy.layout.swap_right(), desc="Move window right"),

# APPLICATIONS
    Key([mod], "Return", lazy.spawn(terminal), desc="Spawn a terminal"),
    Key([mod], "d", lazy.spawn(run_launcher),
    desc="Spawn run launcher"),

# SPAWN DEFAULT APP FOR THIS GROUP
    Key([mod], "t", lazy.function(spawn_default_app), desc="Spawn the default app for the current group"),

# SCREENSHOT
    Key([mod, "control"], "c", lazy.spawn("flameshot screen -c -d 5000"), desc="Wait 5 seconds and take a screenshot"),
    Key([mod], "c", lazy.spawn("flameshot screen -c"), desc="Take a screenshot"),
    Key([mod, "shift"], "c", lazy.spawn("flameshot gui"), desc="Mark an area and screenshot it"),
    Key([], "Print", lazy.spawn("flameshot screen -c"), desc="Take a screenshot"),
    Key(["shift"], "Print", lazy.spawn("flameshot gui"), desc="Mark an area and screenshot it"),

# MUlTIMEDIA
    Key([], "XF86AudioPlay", lazy.spawn("playerctl play-pause"), desc="Play or pause audio with playerctl"),
    Key([], "XF86AudioNext", lazy.spawn("playerctl next"), desc="Skip to the next track with playerctl"),
    Key([], "XF86AudioPrev", lazy.spawn("playerctl previous"), desc="Skip to the previous track with playerctl"),
    Key([], "XF86AudioMute", lazy.spawn("./.config/eww/scripts/eww_vol.sh mute"), desc="Mute"),
    Key([], "XF86AudioRaiseVolume", lazy.spawn("./.config/eww/scripts/eww_vol.sh up"), desc="Volume up 5%"),
    Key([], "XF86AudioLowerVolume", lazy.spawn("./.config/eww/scripts/eww_vol.sh down"), desc="Volume down 5%"),
    Key([], "XF86MonBrightnessUp", lazy.spawn("./.config/eww/scripts/eww_bright.sh up"), desc="Increase brightness 10%"),
    Key([], "XF86MonBrightnessDown", lazy.spawn("./.config/eww/scripts/eww_bright.sh down"), desc="Decrease brightness 10%"),


    Key(["mod1"], "space", lazy.spawn("./.config/eww/scripts/eww_sidebar.sh"), desc="Toggle sidebar"),
    Key([mod], "v", lazy.spawn("rofi -theme '~/.config/rofi/launchers/colorful/style_13.rasi' -modi 'clipboard:greenclip print' -show clipboard -run-command '{cmd}'"), desc="Open clipboard manager"),
    Key([mod], "equal", lazy.spawn("= -- -theme '~/.config/rofi/launchers/colorful/style_13.rasi'"), desc="Run calculator in rofi"),
    Key(["control"], "m", lazy.spawn("find-cursor -c '#4dd0e1' -f -t -r 2"), desc="Launch the program to find the cursor"),

# NOTIFICATIONS
    Key([mod], "n", lazy.spawn("./.config/rofi/rofi_notif_center.sh"), desc="Launch the notification center"),
    Key([], "XF86AudioMedia", lazy.spawn("./.config/rofi/rofi_notif_center.sh"), desc="Launch the notification center"),
    
    Key([mod], "p" ,lazy.spawn("./.config/qtile/scripts/displayselect.sh"), desc="Change display configuration with autorandr"),

]

groups = []

# FOR QWERTY KEYBOARDS
group_names = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0",]

# group_labels = ["1 ", "2 ", "3 ", "4 ", "5 ", "6 ", "7 ", "8 ", "9 ", "0",]
# group_labels = ["", "", "", "", "", "", "", "", "", "",]
group_labels = ["", "︁", "", "", "", "", "", "", "", "",]
# group_labels = ["Web", "Edit/chat", "Image", "Gimp", "Meld", "Video", "Vb", "Files", "Mail", "Music",]

group_layouts = ["monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall",]
#group_layouts = ["monadtall", "matrix", "monadtall", "bsp", "monadtall", "matrix", "monadtall", "bsp", "monadtall", "monadtall",]

group_defaults = ["firefox", "code", "nautilus", run_launcher, run_launcher, "firefox", run_launcher, "discord", "pavucontrol", "terminator -e bpytop",]

for i in range(len(group_names)):
    group = Group(
            name=group_names[i],
            layout=group_layouts[i].lower(),
            label=group_labels[i],
        )
    group.default_app = group_defaults[i]
    groups.append(group)

for i in groups:
    keys.extend([

    #CHANGE WORKSPACES
        Key([mod], i.name, lazy.group[i.name].toscreen(toggle=True), desc=f"Go to workspace {i.name}"),

    # MOVE WINDOW TO SELECTED WORKSPACE 1-10 AND STAY ON WORKSPACE
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name), desc=f"Move window to workspace {i.name}"),
    # MOVE WINDOW TO SELECTED WORKSPACE 1-10 AND FOLLOW MOVED WINDOW TO WORKSPACE
        Key([mod, "shift", "control"], i.name, lazy.window.togroup(i.name) , lazy.group[i.name].toscreen(), desc=f"Move window to workspace {i.name} and follow it there"),
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
    Key([mod], "h",lazy.spawn("sh -c 'echo \"" + show_keys() + '" | rofi -theme "~/.config/rofi/launchers/colorful/style_13.rasi" -dmenu -i -p "?"\''), desc="Print keyboard bindings"),
])

def init_layout_theme():
    return {"margin":5,
            "border_width":2,
            "border_focus": colors['border_focus'],
            "border_normal": colors['border_normal']
            }

layout_theme = init_layout_theme()

layouts = [
    layout.MonadTall(margin=8, border_width=2, border_focus=colors['border_focus'], border_normal=colors['border_normal']),
    layout.MonadWide(margin=8, border_width=2, border_focus=colors['border_focus'], border_normal=colors['border_normal']),
    layout.Matrix(**layout_theme),
    layout.Bsp(**layout_theme),
    layout.Floating(**layout_theme),
    layout.RatioTile(**layout_theme),
    layout.Max(**layout_theme),
    layout.Zoomy(**layout_theme),
]

# WIDGETS FOR THE BAR

def init_widgets_defaults():
    return dict(font="Noto Sans",
                fontsize = 14,
                padding = 2,
                background=colors['bg_color'])

widget_defaults = init_widgets_defaults()

def launch_power_menu():
    qtile.cmd_spawn('./.config/rofi/applets/menu/powermenu.sh')

def init_widgets_list():
    prompt = "{0}@{1}: ".format(os.environ["USER"], socket.gethostname())
    widgets_list = [
        widget.Spacer(
            length=5,
        ),
        widget.TextBox(
            font = "Font Awesome 5 Free Solid",
            text = "",
            foreground = colors['highlight_color'],
            background = colors['bg_color'],
            padding = 5,
            fontsize = 22,
            mouse_callbacks = {"Button1": launch_power_menu}
        ),
        widget.TextBox(
            font="Font Awesome 5 Free Regular",
            text="  ",
            foreground=["#fba922", "#fba922"],
            background=colors['bg_color'],
            padding = 0,
            fontsize=22,
            mouse_callbacks = { "Button1": lazy.spawn("./.config/eww/scripts/eww_calendar.sh") }
        ),
        widget.Clock(
            foreground = colors['fg_color_alt'],
            background = colors['bg_color'],
            fontsize = 22,
            format="%I:%M %P",
            mouse_callbacks = { "Button1": lazy.spawn("./.config/eww/scripts/eww_calendar.sh") }
        ),
        # TODO: Enable this widget on click of clock widget
        # widget.Clock(
        #     foreground = colors['fg_color_alt'],
        #     background = colors['bg_color'],
        #     fontsize = 16,
        #     format = "%m-%d-%y"
        # ),
        widget.Sep(
            linewidth = 1,
            padding = 10,
            foreground = colors['fg_color'],
            background = colors['bg_color']
        ),
        widget.CurrentLayoutIcon(
            foreground=colors['fg_color'],
            background=colors['bg_color'],
            scale=.75,
        ),
        widget.Spacer(),
        widget.GroupBox(
            font="Font Awesome 5 Free Solid",
            fontsize = 22,
            margin_y = 2,
            margin_x = 0,
            padding_y = 6,
            padding_x = 8,
            borderwidth = 0,
            disable_drag = True,
            # active = ["#a9a9a9", "#a9a9a9"],
            active = "#116397",
            inactive = colors['fg_color_alt'],
            rounded = True,
            highlight_method = "text",
            this_current_screen_border = colors['highlight_color'],
            # this_current_screen_border = "#ff3399",
            foreground = colors['fg_color'],
            background = colors['bg_color'],
            hide_unused = True,
        ),
        widget.Spacer(),
        # do not activate in Virtualbox - will break qtile
        widget.ThermalSensor(
            foreground = colors['fg_color_alt'],
            foreground_alert = colors['fg_crit'],
            background = colors['bg_color'],
            metric = True,
            padding = 3,
            threshold = 85,
            fontsize = 22,
        ),
        widget.Sep(),
        arcobattery.BatteryIcon(
            padding=0,
            scale=0.8,
            y_poss=2,
            theme_path=home + "/.config/qtile/icons/battery_icons_horiz",
            update_interval = 5,
            background = colors['bg_color']
        ),
        widget.Battery(
            format='{percent:2.0%} {hour:d}:{min:02d}',
            font='Hack',
            fontsize = 22,
            background = colors['bg_color'],
            padding=10
        ),
    ]
    return widgets_list

widgets_list = init_widgets_list()

def init_widgets_screen1():
    widgets_screen1 = init_widgets_list()
    # Append needed systray widgets only to screen 1. I don't want these to show on my second screen
    widgets_screen1.append(widget.Sep())
    widgets_screen1.append(widget.Systray(background=colors['bg_color'], icon_size=26, padding=6))
    widgets_screen1.append(widget.Spacer(length=5))
    return widgets_screen1

def init_widgets_screen2():
    widgets_screen2 = init_widgets_list()
    widgets_screen2.append(widget.Spacer(length=5))
    return widgets_screen2

def init_screens():
    return [Screen(top=bar.Bar(widgets=init_widgets_screen1(), margin=[8, 8, 0, 8], size=36, opacity=0.8)),
            Screen(top=bar.Bar(widgets=init_widgets_screen2(), margin=[8, 8, 0, 8], size=36, opacity=0.8))]
screens = init_screens()

# MOUSE CONFIGURATION
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = []

dgroups_key_binder = None
dgroups_app_rules = []

# ASSIGN APPLICATIONS TO A SPECIFIC GROUPNAME
# BEGIN

#########################################################
################ assign apps to groups ##################
#########################################################
# @hook.subscribe.client_new
# def assign_app_group(client):
#     d = {}
#     #####################################################################################
#     ### Use xprop fo find  the value of WM_CLASS(STRING) -> First field is sufficient ###
#     #####################################################################################
#     d[group_names[0]] = ["Navigator", "Firefox", "Vivaldi-stable", "Vivaldi-snapshot", "Chromium", "Google-chrome", "Brave", "Brave-browser",
#               "navigator", "firefox", "vivaldi-stable", "vivaldi-snapshot", "chromium", "google-chrome", "brave", "brave-browser", ]
#     d[group_names[1]] = [ "Atom", "Subl", "Geany", "Brackets", "Code-oss", "Code", "TelegramDesktop", "Discord",
#                "atom", "subl", "geany", "brackets", "code-oss", "code", "telegramDesktop", "discord", ]
#     d[group_names[2]] = ["Inkscape", "Nomacs", "Ristretto", "Nitrogen", "Feh",
#               "inkscape", "nomacs", "ristretto", "nitrogen", "feh", ]
#     d[group_names[3]] = ["Gimp", "gimp" ]
#     d[group_names[4]] = ["Meld", "meld", "org.gnome.meld" "org.gnome.Meld" ]
#     d[group_names[5]] = ["Vlc","vlc", "Mpv", "mpv" ]
#     d[group_names[6]] = ["VirtualBox Manager", "VirtualBox Machine", "Vmplayer",
#               "virtualbox manager", "virtualbox machine", "vmplayer", ]
#     d[group_names[7]] = ["Thunar", "Nemo", "Caja", "Nautilus", "org.gnome.Nautilus", "Pcmanfm", "Pcmanfm-qt",
#               "thunar", "nemo", "caja", "nautilus", "org.gnome.nautilus", "pcmanfm", "pcmanfm-qt", ]
#     d[group_names[8]] = ["Evolution", "Geary", "Mail", "Thunderbird",
#               "evolution", "geary", "mail", "thunderbird" ]
#     d[group_names[9]] = ["Spotify", "Pragha", "Clementine", "Deadbeef", "Audacious",
#               "spotify", "pragha", "clementine", "deadbeef", "audacious" ]
#     ######################################################################################
#
# wm_class = client.window.get_wm_class()[0]
#
#     for i in range(len(d)):
#         if wm_class in list(d.values())[i]:
#             group = list(d.keys())[i]
#             client.togroup(group)
#             client.group.cmd_toscreen(toggle=False)

# END
# ASSIGN APPLICATIONS TO A SPECIFIC GROUPNAME

main = None

@hook.subscribe.startup_once
def start_once():
    # Set the cursor to something sane in X
    subprocess.Popen(['xsetroot', '-cursor_name', 'left_ptr'])

@hook.subscribe.startup
def start_always():
    home = os.path.expanduser('~')
    subprocess.call([home + '/.config/qtile/scripts/autostart.sh'])

follow_mouse_focus = True
bring_front_click = True
cursor_warp = False

floating_layout = layout.Floating(float_rules=[
    *layout.Floating.default_float_rules,
    Match(wm_class='confirmreset'),  # gitk
    Match(wm_class='makebranch'),  # gitk
    Match(wm_class='maketag'),  # gitk
    Match(title='branchdialog'),  # gitk
    Match(wm_class='pinentry'), # GPG key password entry
    Match(wm_class='ssh-askpass'), # ssh-askpass
    Match(wm_class='MEGAsync'),
    Match(wm_class='Open File'),
    Match(wm_class='Arandr'),
], fullscreen_border_width = 0, border_width = 0)
Match(title='branchdialog'),  # gitk
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
