WALL_DIR="$HOME/Pictures/.wallpaper/"

# Ensure awww daemon is running
if ! pidof awww-daemon >/dev/null; then
    awww-daemon &
    sleep 0.5
fi


# MINIMAL ROFI THEME (clean / matrix-like default)
GRID_THEME='


listview {
    columns: 3;
    lines: 2;
    flow: horizontal;
    fixed-height: true;
    fixed-columns: true;
    scrollbar: false;
}

element-icon {
    size: 180px;
}

'
SELECTED=$(
for img in "$WALL_DIR"/*; do
    [[ "$img" =~ \.(jpg|jpeg|png|webp|PNG|JPG)$ ]] || continue
    printf "%s\0icon\x1f%s\n" "$(basename "$img")" "$img"
done | rofi \
-dmenu \
-i \
-show-icons \
-theme-str "$GRID_THEME" \
-p "" \
-name "wallpaper-picker"

)

if [ -n "$SELECTED" ]; then
    awww img "$WALL_DIR/$SELECTED" \
        --transition-type wipe \
        --transition-duration 1
fi
