#!/bin/bash

WALLPAPER_DIR="$HOME/.config/hypr/wallpapers"
MONITOR="eDP-1"

while true; do
    mapfile -t wallpapers < <(find "$WALLPAPER_DIR" -maxdepth 1 -type f \
        -iregex '.*\.\(jpg\|jpeg\|png\|gif\|webp\)' | sort)

    if [[ ${#wallpapers[@]} -eq 0 ]]; then
        echo "No wallpapers found in $WALLPAPER_DIR"
        exit 1
    fi

    for wallpaper in "${wallpapers[@]}"; do
        hyprctl hyprpaper wallpaper "$MONITOR, $wallpaper"
        sleep 30
    done
done
