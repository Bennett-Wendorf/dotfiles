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
from libqtile.config import Drag, Key, Screen, Group, Drag, Click, Rule
from libqtile.command import lazy
from libqtile import layout, bar, widget, hook
from libqtile.widget import Spacer
import arcobattery
from libqtile.log_utils import logger

#mod4 or mod = super key
mod = "mod4"
mod1 = "alt"
mod2 = "control"
home = os.path.expanduser('~')
terminal = "terminator"
run_launcher = "dmenu_run -i -fn 'Hack-10' -nb '#2E3440' -nf '#88C0D0' -sb '#88C0D0' -sf '#2E3440'"

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
    logger.warning(groupIndex)
    if qtile.current_group is not None and groupIndex is not None:
        app = groups[groupIndex].default_app
        logger.warning("Launching: " + app)
        qtile.cmd_spawn(app)
    elif qtile.current_group is not None and groupIndex is None:
        qtile.cmd_spawn(run_launcher)

# def show_keys():
# 	key_help = ""
# 	for k in keys:
# 		mods = ""

# 		for m in k.modifiers:
# 			if m == "mod4":
# 				mods += "Super + "
# 			else:
# 				mods += m.capitalize() + " + "

# 		if len(k.key) > 1:
# 			mods += k.key.capitalize()
# 		else:
# 			mods += k.key

# 		key_help += "{:<30} {}".format(mods, k.desc + "\n")

# 	return key_help

keys = [

# WINDOW CONTROLS
    Key([mod, "shift"], "q", lazy.window.kill(), desc="Kill current window"),
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc="Toggle the fullscreen status of the current window"),
    Key([mod], "a", lazy.window.toggle_floating(), desc="Toggle floating status of the current window"),

# QTILE FUNCTIONS
    Key([mod, "shift"], "r", lazy.restart(), desc="Restart Qtile"),
    Key([mod, "shift"],"e", lazy.shutdown(), desc="Shutdown Qtile"),

# QTILE LAYOUT KEYS
    Key([mod], "n", lazy.layout.normalize(), desc="Normalize the layout"),
    Key([mod], "space", lazy.next_layout(), desc="Change the layout to the next option"),

# CHANGE FOCUS
    Key([mod], "Up", lazy.layout.up(), desc="Change focus up"),
    Key([mod], "Down", lazy.layout.down(), desc="Change focus down"),
    Key([mod], "Left", lazy.layout.left(), desc="Change focus left"),
    Key([mod], "Right", lazy.layout.right(), desc="Change focus right"),
    Key([mod], "k", lazy.layout.up(), desc="Change focus up"),
    Key([mod], "j", lazy.layout.down(), desc="Change focus down"),
    Key([mod], "h", lazy.layout.left(), desc="Change focus left"),
    Key([mod], "l", lazy.layout.right(), desc="Change focus right"),

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
    desc="Spawn dmenu"),

# SPAWN DEFAULT APP FOR THIS GROUP
    Key([mod], "t", lazy.function(spawn_default_app)),

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
    Key([], "XF86AudioMute", lazy.spawn("amixer -D pulse set Master 1+ toggle"), desc="Mute"),
    Key([], "XF86AudioRaiseVolume", lazy.spawn("amixer -D pulse sset Master 5%+"), desc="Volume up 5%"),
    Key([], "XF86AudioLowerVolume", lazy.spawn("amixer -D pulse sset Master 5%-"), desc="Volume down 5%"),
    Key([], "XF86MonBrightnessUp", lazy.spawn("xbacklight -inc 10"), desc="Increase brightness 10%"),
    Key([], "XF86MonBrightnessDown", lazy.spawn("xbacklight -dec 10"), desc="Decrease brightness 10%"),

    # Key([mod], "h",lazy.spawn("sh -c 'echo \"" + show_keys() + '" | rofi -dmenu -i -p "?"\''), desc="Print keyboard bindings"),

# TODO: Helper apps
    # Need to add things like '=' and 'greenclip' here

]

groups = []

# FOR QWERTY KEYBOARDS
group_names = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0",]

# group_labels = ["1 ", "2 ", "3 ", "4 ", "5 ", "6 ", "7 ", "8 ", "9 ", "0",]
# group_labels = ["", "", "", "", "", "", "", "", "", "",]
group_labels = ["", "", "", "", "", "", "", "", "", "",]
# group_labels = ["", "", "", "", "", "", "", "", "", "",]
# group_labels = ["Web", "Edit/chat", "Image", "Gimp", "Meld", "Video", "Vb", "Files", "Mail", "Music",]

group_layouts = ["monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall",]
#group_layouts = ["monadtall", "matrix", "monadtall", "bsp", "monadtall", "matrix", "monadtall", "bsp", "monadtall", "monadtall",]

group_defaults = ["firefox", "code", "nautilus", run_launcher, run_launcher, run_launcher, run_launcher, "discord", "pavucontrol", "terminator -e bpytop",]

for i in range(len(group_names)):
    group = Group(
            name=group_names[i],
            layout=group_layouts[i].lower(),
            label=group_labels[i],
        )
    group.default_app = group_defaults[i]
    logger.warning(group)
    logger.warning(vars(group))
    groups.append(group)
for i in groups:
    keys.extend([

    #CHANGE WORKSPACES
        Key([mod], i.name, lazy.group[i.name].toscreen()),
        Key([mod], "Tab", lazy.screen.next_group(), desc="Go to next workspace"),
        Key([mod, "shift" ], "Tab", lazy.screen.prev_group(), desc="Go to previous workspace"),

    # MOVE WINDOW TO SELECTED WORKSPACE 1-10 AND STAY ON WORKSPACE
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name)),
    # MOVE WINDOW TO SELECTED WORKSPACE 1-10 AND FOLLOW MOVED WINDOW TO WORKSPACE
        # Key([mod, "shift"], i.name, lazy.window.togroup(i.name) , lazy.group[i.name].toscreen()),
    ])


def init_layout_theme():
    return {"margin":5,
            "border_width":2,
            # TODO: Change this color to a variable
            "border_focus": "#5e81ac",
            # TODO: Change this color to a variable
            "border_normal": "#4c566a"
            }

layout_theme = init_layout_theme()

layouts = [
    # TODO: Change these colors to variables
    layout.MonadTall(margin=8, border_width=2, border_focus="#5e81ac", border_normal="#4c566a"),
    layout.MonadWide(margin=8, border_width=2, border_focus="#5e81ac", border_normal="#4c566a"),
    layout.Matrix(**layout_theme),
    layout.Bsp(**layout_theme),
    layout.Floating(**layout_theme),
    layout.RatioTile(**layout_theme),
    layout.Max(**layout_theme),
    layout.Zoomy(**layout_theme)
]

# COLORS FOR THE BAR

# TODO: Define these colors in a variable
def init_colors():
    return [["#2F343F", "#2F343F"], # color 0
            ["#2F343F", "#2F343F"], # color 1
            ["#c0c5ce", "#c0c5ce"], # color 2
            ["#fba922", "#fba922"], # color 3
            ["#3384d0", "#3384d0"], # color 4
            ["#f3f4f5", "#f3f4f5"], # color 5
            ["#cd1f3f", "#cd1f3f"], # color 6
            ["#62FF00", "#62FF00"], # color 7
            ["#6790eb", "#6790eb"], # color 8
            ["#a9a9a9", "#a9a9a9"]] # color 9

colors = init_colors()

# WIDGETS FOR THE BAR

def init_widgets_defaults():
    return dict(font="Noto Sans",
                fontsize = 14,
                padding = 2,
                background=colors[1])

widget_defaults = init_widgets_defaults()

def init_widgets_list():
    prompt = "{0}@{1}: ".format(os.environ["USER"], socket.gethostname())
    widgets_list = [
                # TODO: Check why these don't all show the same size
               widget.GroupBox(
                        # font="FontAwesomeSolid",
                        fontsize = 18,
                        # margin_y = -1,
                        margin_y = 1,
                        margin_x = 0,
                        padding_y = 6,
                        # padding_x = 5,
                        padding_x = 10,
                        borderwidth = 0,
                        disable_drag = True,
                        active = colors[9],
                        inactive = colors[5],
                        rounded = True,
                        highlight_method = "text",
                        this_current_screen_border = colors[8],
                        foreground = colors[2],
                        background = colors[1],
                        hide_unused = True,
                        ),
               widget.Sep(
                        linewidth = 1,
                        padding = 10,
                        foreground = colors[2],
                        background = colors[1]
                        ),
               widget.CurrentLayout(
                        font = "Noto Sans Bold",
                        foreground = colors[5],
                        background = colors[1]
                        ),
               widget.Sep(
                        linewidth = 1,
                        padding = 10,
                        foreground = colors[2],
                        background = colors[1]
                        ),
               widget.WindowName(font="Noto Sans",
                        fontsize = 12,
                        foreground = colors[5],
                        background = colors[1],
                        ),
                widget.TextBox(
                    font="FontAwesome",
                    fontsize="40",
                    # text=", , , , , , , , , "
                    text=", , , , , , "
                ),
               # widget.Net(
               #          font="Noto Sans",
               #          fontsize=12,
               #          interface="enp0s31f6",
               #          foreground=colors[2],
               #          background=colors[1],
               #          padding = 0,
               #          ),
               # widget.Sep(
               #          linewidth = 1,
               #          padding = 10,
               #          foreground = colors[2],
               #          background = colors[1]
               #          ),
               # widget.NetGraph(
               #          font="Noto Sans",
               #          fontsize=12,
               #          bandwidth="down",
               #          interface="auto",
               #          fill_color = colors[8],
               #          foreground=colors[2],
               #          background=colors[1],
               #          graph_color = colors[8],
               #          border_color = colors[2],
               #          padding = 0,
               #          border_width = 1,
               #          line_width = 1,
               #          ),
               # widget.Sep(
               #          linewidth = 1,
               #          padding = 10,
               #          foreground = colors[2],
               #          background = colors[1]
               #          ),
               # # do not activate in Virtualbox - will break qtile
            #    widget.ThermalSensor(
            #             foreground = colors[5],
            #             foreground_alert = colors[6],
            #             background = colors[1],
            #             metric = True,
            #             padding = 3,
            #             threshold = 80
            #             ),
               # # battery option 1  ArcoLinux Horizontal icons do not forget to import arcobattery at the top
               # widget.Sep(
               #          linewidth = 1,
               #          padding = 10,
               #          foreground = colors[2],
               #          background = colors[1]
               #          ),
               arcobattery.BatteryIcon(
                        padding=0,
                        scale=0.7,
                        y_poss=2,
                        theme_path=home + "/.config/qtile/icons/battery_icons_horiz",
                        update_interval = 5,
                        background = colors[1]
                        ),
               # # battery option 2  from Qtile
               # widget.Sep(
               #          linewidth = 1,
               #          padding = 10,
               #          foreground = colors[2],
               #          background = colors[1]
               #          ),
            #    widget.Battery(
            #             font="Noto Sans",
            #             update_interval = 10,
            #             fontsize = 12,
            #             foreground = colors[5],
            #             background = colors[1],
	        #             ),
            #    widget.TextBox(
            #             font="FontAwesome",
            #             text="  ",
            #             foreground=colors[6],
            #             background=colors[1],
            #             padding = 0,
            #             fontsize=16
            #             ),
            #    widget.CPUGraph(
            #             border_color = colors[2],
            #             fill_color = colors[8],
            #             graph_color = colors[8],
            #             background=colors[1],
            #             border_width = 1,
            #             line_width = 1,
            #             core = "all",
            #             type = "box"
            #             ),
               # widget.Sep(
               #          linewidth = 1,
               #          padding = 10,
               #          foreground = colors[2],
               #          background = colors[1]
               #          ),
            #    widget.TextBox(
            #             font="FontAwesome",
            #             text="  ",
            #             foreground=colors[4],
            #             background=colors[1],
            #             padding = 0,
            #             fontsize=16
            #             ),
            #    widget.Memory(
            #             font="Noto Sans",
            #             format = '{MemUsed}M/{MemTotal}M',
            #             update_interval = 1,
            #             fontsize = 12,
            #             foreground = colors[5],
            #             background = colors[1],
            #            ),
               # widget.Sep(
               #          linewidth = 1,
               #          padding = 10,
               #          foreground = colors[2],
               #          background = colors[1]
               #          ),
               widget.TextBox(
                        font="FontAwesome",
                        text="  ",
                        foreground=colors[3],
                        background=colors[1],
                        padding = 0,
                        fontsize=16
                        ),
               widget.Clock(
                        foreground = colors[5],
                        background = colors[1],
                        fontsize = 12,
                        format="%m-%d-%y %I:%M %P"
                        ),
            #    widget.Sep(
            #             linewidth = 1,
            #             padding = 10,
            #             foreground = colors[2],
            #             background = colors[1]
            #             ),
               widget.Systray(
                        background=colors[1],
                        icon_size=20,
                        padding = 4
                        ),
              ]
    return widgets_list

widgets_list = init_widgets_list()


def init_widgets_screen1():
    widgets_screen1 = init_widgets_list()
    return widgets_screen1

def init_widgets_screen2():
    widgets_screen2 = init_widgets_list()
    return widgets_screen2

widgets_screen1 = init_widgets_screen1()
widgets_screen2 = init_widgets_screen2()


def init_screens():
    return [Screen(top=bar.Bar(widgets=init_widgets_screen1(), size=26, opacity=0.8)),
            Screen(top=bar.Bar(widgets=init_widgets_screen2(), size=26, opacity=0.8))]
screens = init_screens()


# MOUSE CONFIGURATION
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size())
]

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
    home = os.path.expanduser('~')
    subprocess.call([home + '/.config/qtile/scripts/autostart.sh'])

@hook.subscribe.startup
def start_always():
    # Set the cursor to something sane in X
    subprocess.Popen(['xsetroot', '-cursor_name', 'left_ptr'])

@hook.subscribe.client_new
def set_floating(window):
    if (window.window.get_wm_transient_for()
            or window.window.get_wm_type() in floating_types):
        window.floating = True

# RULES FOR FLOATING WINDOWS
floating_types = ["notification", "toolbar", "splash", "dialog"]

follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(float_rules=[
    {'wmclass': 'Arcolinux-welcome-app.py'},
    {'wmclass': 'Arcolinux-tweak-tool.py'},
    {'wmclass': 'confirm'},
    {'wmclass': 'dialog'},
    {'wmclass': 'download'},
    {'wmclass': 'error'},
    {'wmclass': 'file_progress'},
    {'wmclass': 'notification'},
    {'wmclass': 'splash'},
    {'wmclass': 'toolbar'},
    {'wmclass': 'confirmreset'},
    {'wmclass': 'makebranch'},
    {'wmclass': 'maketag'},
    {'wmclass': 'Arandr'},
    {'wmclass': 'feh'},
    {'wmclass': 'Galculator'},
    {'wmclass': 'arcolinux-logout'},
    {'wmclass': 'xfce4-terminal'},
    {'wname': 'branchdialog'},
    {'wname': 'Open File'},
    {'wname': 'pinentry'},
    {'wmclass': 'ssh-askpass'},

],  fullscreen_border_width = 0, border_width = 0)
auto_fullscreen = True

focus_on_window_activation = "focus" # or smart

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
