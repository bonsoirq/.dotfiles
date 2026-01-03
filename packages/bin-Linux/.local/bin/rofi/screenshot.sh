#!/usr/bin/env bash

choice=$(printf "🖵  Screen\n▢  Application\n▨  Selection" | rofi -dmenu)

case "$choice" in
  "🖵  Screen") hyprshot --clipboard-only -m output ;;
  "▢  Application") hyprshot --clipboard-only -m window ;;
  "▨  Selection") hyprshot --clipboard-only -m region ;;
esac