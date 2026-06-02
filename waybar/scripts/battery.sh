#!/bin/bash

# 1. Initialize totals
total_now=0
total_full=0
is_charging=false

# 2. Loop through all detected batteries (BAT0, BAT1, etc.)
for bat in /sys/class/power_supply/BAT*; do
    # Get current charge and max capacity (using energy or charge files)
    if [ -f "$bat/charge_now" ]; then
        now=$(cat "$bat/charge_now")
        full=$(cat "$bat/charge_full")
    elif [ -f "$bat/energy_now" ]; then
        now=$(cat "$bat/energy_now")
        full=$(cat "$bat/energy_full")
    else
        continue
    fi

    total_now=$((total_now + now))
    total_full=$((total_full + full))

    # Check if ANY of the batteries are charging
    if grep -q "Charging" "$bat/status"; then
        is_charging=true
    fi
done

# 3. Calculate combined percentage (Safely)
if [ "$total_full" -gt 0 ]; then
    capacity=$(( 100 * total_now / total_full ))
else
    capacity=0
fi

# 4. Icons & Logic
charging_icons=(󰢜 󰂆 󰂇 󰂈 󰢝 󰂉 󰢞 󰂊 󰂋 󰂅)
default_icons=(󰁺 󰁻 󰁼 󰁽 󰁾 󰁿 󰂀 󰂁 󰂂 󰁹)

index=$((capacity / 10))
[ $index -ge 10 ] && index=9

if [ "$is_charging" = true ]; then
    icon=${charging_icons[$index]}
    status="Charging"
else
    icon=${default_icons[$index]}
    status="Discharging"
fi

# 5. Build ASCII bar
filled=$((capacity / 10))
empty=$((10 - filled))
bar=""
for ((i=0; i<filled; i++)); do bar+="█"; done
for ((i=0; i<empty; i++)); do bar+="░"; done

# 6. Colors
if [ "$capacity" -lt 20 ]; then fg="#bf616a"; elif [ "$capacity" -lt 55 ]; then fg="#fab387"; else fg="#56b6c2"; fi

# 7. Final JSON
echo "{\"text\":\"<span foreground='$fg'>$icon [$bar] $capacity%</span>\", \"tooltip\":\"Total Capacity: $capacity%\nStatus: $status\"}"
