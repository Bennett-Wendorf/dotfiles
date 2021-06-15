local filesystem = require('gears.filesystem')

-- Thanks to jo148 on github for making rofi dpi aware!
local with_dpi = require('beautiful').xresources.apply_dpi
local get_dpi = require('beautiful').xresources.get_dpi
local rofi_command = 'env rofi -show drun --width 30'
local dmenu_command = 'env dmenu_run -i -fn "Hack-10"'

return {
  -- List of apps to start by default on some actions
  default = {
    terminal = 'env terminator',
    rofi = rofi_command,
    calc = "=",
    lock = '/home/bennett/.config/i3lock/i3lock.sh',
    quake = 'terminator',
    screenshot = 'flameshot screen -c',
    region_screenshot = 'flameshot gui',
    delayed_screenshot = 'flameshot screen -c -d 5000',
    -- clipboard_manager = 'copyq menu',
    clipboard_manager = 'rofi -modi "clipboard:greenclip print" -show clipboard -run-command "{cmd}"',

    -- Editing these also edits the default program
    -- associated with each tag/workspace
    browser = 'env firefox',
    editor = 'code', -- gui text editor
    social = 'env discord',
    game = rofi_command,
    files = 'thunar',
    music = rofi_command,
    debug = 'terminator -e bpytop'
  },
  -- List of apps to start once on start-up
  run_on_start_up = {
    -- 'compton --config ' .. filesystem.get_configuration_dir() .. '/configuration/compton.conf',
    --'blueberry-tray', -- Bluetooth tray icon
    --'xfce4-power-manager', -- Power manager
    -- 'ibus-daemon --xim --daemonize', -- Ibus daemon for keyboard
    -- 'scream-start', -- scream audio sink
    -- '/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 & eval $(gnome-keyring-daemon -s --components=pkcs11,secrets,ssh,gpg)', -- credential manager
    --'/usr/lib/x86_64-linux-gnu/libexec/polkit-kde-authentication-agent-1 & eval $(gnome-keyring-daemon -s --components=pkcs11,secrets,ssh,gpg)', -- credential manager
    --'blueman-tray', -- bluetooth tray
    -- 'geary --hidden', -- Email client
    -- Add applications that need to be killed between reloads
    -- to avoid multipled instances, inside the awspawn script
    'flameshot',
    'megasync',
    'killall onedrive_tray', 'onedrive_tray',
    'screenrotator',
    'copyq',
    'greenclip daemon',
    -- 'protonvpn', 'killall protonvpn-tray', 'protonvpn-tray',
    'wal -R',
    'nitrogen --restore',
    'xss-lock --transfer-sleep-lock -- /home/bennett/.config/i3lock/i3lock.sh --nofork',
    'killall xidlehook', "xidlehook --not-when-fullscreen --not-when-audio --timer 1800 '~/.config/i3lock/i3lock.sh' ''",
    -- 'xfce4-power-manager',
    'killall cbatticon', "cbatticon -n -r 3 -c 'poweroff' BAT0", --A simple battery icon that lives in the system tray
    'autorandr -c', --Makes sure that the correct display configuration is set when logging in
  },
}
