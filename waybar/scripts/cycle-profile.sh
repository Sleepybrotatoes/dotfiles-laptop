#!/bin/bash
# ── cycle-profile.sh ──────────────────────────────────────
# Description: Cycles through power-profiles-daemon states
# ──────────────────────────────────────────────────────────

current=$(powerprofilesctl get)

if [ "$current" == "power-saver" ]; then
    powerprofilesctl set balanced
elif [ "$current" == "balanced" ]; then
    powerprofilesctl set performance
else
    powerprofilesctl set power-saver
fi