#!/bin/bash

# RUTAS - Verifica que .Wallpaper tenga el punto inicial si es carpeta oculta
WALL_DIR="$HOME/Pictures/.Wallpaper"
CACHE_DIR="$HOME/.cache/rofi-walls"

mkdir -p "$CACHE_DIR"

# 1. Generar miniaturas (Magick)
while read -r img; do
    [ -z "$img" ] && continue
    name=$(basename "$img")
    if [ ! -f "$CACHE_DIR/$name" ]; then
        magick "$img" -thumbnail 200x200^ -gravity center -extent 200x200 "$CACHE_DIR/$name"
    fi
done < <(find "$WALL_DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.webp" \))

# 2. CONSTRUIR LA LISTA (Usando un formato más simple)
LISTA=""
while read -r path; do
    name=$(basename "$path")
    # Formato: Nombre\0icon\x1fRuta
    LISTA+="$name\x00icon\x1f$CACHE_DIR/$name\n"
done < <(find "$WALL_DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.webp" \))

# 3. Lanzar Rofi
# Usamos -raw-window-icons por si acaso
SELECCION=$(echo -e "$LISTA" | rofi -dmenu -i -p "󰸉 Wallpaper" \
    -show-icons \
    -sep '\n' \
    -theme-str '
    window { width: 750px; height: 550px; border: 2px; }
    listview { columns: 3; lines: 3; spacing: 15px; padding: 20px; fixed-height: true; }
    element { orientation: vertical; padding: 10px; border-radius: 10px; background-color: transparent; }
    element-icon { size: 150px; horizontal-align: 0.5; }
    element-text { horizontal-align: 0.5; text-color: #cdd6f4; }
    ')

# 4. APLICAR
if [ -z "$SELECCION" ]; then
    exit 0
fi

FULL_PATH="$WALL_DIR/$SELECCION"

if [ -f "$FULL_PATH" ]; then
    swww img "$FULL_PATH" --transition-type grow --transition-fps 60
else
    # Si falla por los espacios, intentamos con comillas
    swww img "${FULL_PATH}" --transition-type grow --transition-fps 60
fi
