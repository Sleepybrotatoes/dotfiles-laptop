#!/bin/bash

# 1. Get current and max brightness
brightness=$(brightnessctl get)
max_brightness=$(brightnessctl max)

# 2. Use awk for floating point math and rounding
# This ensures that 99.5% and above becomes 100%
percent=$(echo "$brightness $max_brightness" | awk '{print int(($1/$2 * 100) + 0.5)}')

# 3. Calculate blocks (10 block total)
filled=$((percent / 10))
[ $filled -gt 10 ] && filled=10 # Safety cap
empty=$((10 - filled))

# 4. Build the ASCII bar using a loop (more reliable than seq)
ascii_bar=""
for ((i=0; i<filled; i++)); do ascii_bar+="█"; done
for ((i=0; i<empty; i++)); do ascii_bar+="░"; done

# 5. Icon and Color Logic
icon="󰛨"
if [ "$percent" -lt 20 ]; then
    fg="#bf616a" # Red
elif [ "$percent" -lt 55 ]; then
    fg="#fab387" # Orange
else
    fg="#56b6c2" # Cyan
fi

# 6. Tooltip info
device=$(brightnessctl --machine-readable | awk -F, 'NR==1 {print $1}')
tooltip="Brightness: $percent%\nDevice: $device"

# 7. JSON output
echo "{\"text\":\"<span foreground='$fg'>$icon [$ascii_bar] $percent%</span>\", \"tooltip\":\"$tooltip\"}"
