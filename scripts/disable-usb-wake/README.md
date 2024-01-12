# To Use

If username is something other than "bennett", modify the service to point to the correct location of the script.

Hard link the service to the services directory with `ln disable-usb-wake.service /etc/systemd/system/`.

Enable the new service with `sudo systemctl enable disable-usb-wake`.
