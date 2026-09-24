#!/bin/bash

# IMPORTANTE: No pongas espacios antes ni después del '='
ARCHIVO="$HOME/.config/rofi/atajos.txt"

cat "$ARCHIVO" | rofi -dmenu -i -p "󰌌 Cheatsheet"
