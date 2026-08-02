#!/bin/bash

# 1. Get the raw output from wpctl
# Example output: "Volume: 0.45" or "Volume: 1.20 [MUTED]"
raw_output=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)

# 2. Extract volume and convert to a clean integer (e.g., 0.45 -> 45)
# We use awk to multiply by 100 and round to the nearest whole number
vol_int=$(echo "$raw_output" | awk '{print int($2 * 100 + 0.5)}')

# 3. Check for Mute status
if [[ "$raw_output" == *"[MUTED]"* ]]; then
    is_muted=true
else
    is_muted=false
fi

# 4. Get Sink Name (Safely)
# This grabs the active sink name and removes any extra spaces
sink=$(wpctl status | grep -A 10 "Sinks:" | grep "*" | awk -F. '{print $2}' | sed 's/^ //' | cut -d'[' -f1 | xargs)
[ -z "$sink" ] && sink="Default Output"

# 5. Icon and Color Logic
if [ "$is_muted" = true ]; then
    icon="󰝟"
    fg="#bf616a" # Red
    tooltip="Muted | $sink"
else
    if [ "$vol_int" -eq 0 ]; then icon=""; elif [ "$vol_int" -lt 50 ]; then icon=""; else icon=""; fi
    if [ "$vol_int" -lt 10 ]; then fg="#bf616a"; elif [ "$vol_int" -lt 50 ]; then fg="#fab387"; else fg="#56b6c2"; fi
    tooltip="Volume: ${vol_int}% | $sink"
fi

# 6. Build the ASCII Bar without using 'seq' (Much more stable)
filled=$((vol_int / 10))
[ $filled -gt 10 ] && filled=10  # Cap at 10 blocks for 100%+ volume
empty=$((10 - filled))

bar=""
for ((i=0; i<filled; i++)); do bar+="█"; done
for ((i=0; i<empty; i++)); do bar+="░"; done
ascii_bar="[$bar]"

# 7. Final JSON Output
echo "{\"text\":\"<span foreground='$fg'>$icon $ascii_bar ${vol_int}%</span>\", \"tooltip\":\"$tooltip\"}"
