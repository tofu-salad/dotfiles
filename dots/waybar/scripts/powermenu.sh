#!/usr/bin/env bash

dir="$HOME/.config/waybar/icons"

choice=$(
        {
                printf 'Logout\0icon\x1f%s\n' "$dir/log-out.png"
                printf 'Shutdown\0icon\x1f%s\n' "$dir/power.png"
        } | rofi -dmenu -i -p "Power" -show-icons -theme $HOME/.config/rofi/power.rasi
)

case "$choice" in
        Logout) swaymsg exit ;;
        Shutdown) systemctl poweroff ;;
esac
