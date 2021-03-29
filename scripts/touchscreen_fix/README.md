# How to Set Up

Ensure that resume.sh is executable. If not, run "sudo chmod +x resume.sh"

"sudo mkdir /opt/touchscreen_fix"
"sudo ln resume.sh /opt/touchscreen_fix/"
"sudo ln touchscreen-fix.service /etc/systemd/system/"
"sudo systemctl daemon-reload"
"sudo systemctl enable touchscreen-fix.service"

The scripts for this fix come from [this](https://bbs.archlinux.org/viewtopic.php?id=190751) Arch Linux forum post. Thanks to user MaTachi over there.
