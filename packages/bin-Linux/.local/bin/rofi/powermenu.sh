#!/usr/bin/env bash

choice=$(printf "  Lock\n󰍃  Logout\n󰒲  Suspend\n  Reboot\n  Shutdown" | rofi -dmenu)

case "$choice" in
  "  Lock") hyprlock ;;
  "󰍃  Logout") hyprctl dispatch exit ;;
  "󰒲  Suspend") hyprlock & sleep 1 && systemctl suspend ;;
  "  Reboot") systemctl reboot ;;
  "  Shutdown") systemctl poweroff ;;
esac
