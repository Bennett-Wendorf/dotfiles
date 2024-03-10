#!/bin/sh

declare -a devices=(XHCI TXHC TDM0 TDM1 TRP0 TRP1 TRP2 TRP3 PEG0 RP10)
#declare -a devices=(XHCI)
for device in "${devices[@]}"; do
    if grep -qw ^$device.*enabled /proc/acpi/wakeup; then
        sudo sh -c "echo $device > /proc/acpi/wakeup"
    fi
done

sudo sh -c "echo disabled > /sys/bus/i2c/devices/i2c-PIXA3854:00/power/wakeup" # Disable the touchpad from generating wakeup events

sudo sh -c "echo disabled > /sys/bus/usb/devices/3-3/power/wakeup"
sudo sh -c "echo disabled > /sys/bus/thunderbolt/devices/0-0/power/wakeup"
sudo sh -c "echo disabled > /sys/bus/thunderbolt/devices/1-0/power/wakeup"
sudo sh -c "echo disabled > /sys/bus/thunderbolt/devices/domain0/power/wakeup"
sudo sh -c "echo disabled > /sys/bus/thunderbolt/devices/domain1/power/wakeup"
sudo sh -c "echo disabled > /sys/bus/acpi/devices/PNP0C0A:00/power/wakeup"
#sudo sh -c "echo disabled > /sys/bus/acpi/devices/PNP0C0D:00/power/wakeup"
sudo sh -c "echo disabled > /sys/bus/platform/devices/alarmtimer.0.auto/power/wakeup"
sudo sh -c "echo disabled > /sys/bus/platform/devices/rtc_cmos/power/wakeup"
