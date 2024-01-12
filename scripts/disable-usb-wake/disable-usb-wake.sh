#!/bin/sh

declare -a devices=(XHCI TXHC TDM0 TDM1 TRP0 TRP1 TRP2 TRP3)
for device in "${devices[@]}"; do
    if grep -qw ^$device.*enabled /proc/acpi/wakeup; then
        sudo sh -c "echo $device > /proc/acpi/wakeup"
    fi
done
