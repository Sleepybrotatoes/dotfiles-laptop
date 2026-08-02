#!/bin/bash
# ── thinkpad-profile.sh ───────────────────────────────────  
# Description: Display current ThinkPad power profile 
# Usage: Called by Waybar `custom/thinkpad-profile`
# ──────────────────────────────────────────────────────────  

profile=$(powerprofilesctl get)

case "$profile" in
  performance)
    text="RAZGON"
    fg="#bf616a"
    ;;
  balanced)
    text="STABILIZATION"
    fg="#fab387"
    ;;
  power-saver)
    text="REACTOR SLEEP"
    fg="#56b6c2"
    ;;
  *)
    text="THINKPAD ??"
    fg="#ffffff"
    ;;
esac

echo "<span foreground='$fg'>$text</span>"