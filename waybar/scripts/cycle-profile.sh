#!/bin/bash
# ── cycle-profile.sh ──────────────────────────────────────
# Description: Cycles through tlp states
# ──────────────────────────────────────────────────────────

current=$(tlp get)

if [ "$current" == "power-saver" ]; then
    tlp set balanced
elif [ "$current" == "balanced" ]; then
    tlp set performance
else
    tlp set power-saver
fi