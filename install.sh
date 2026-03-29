#!/bin/bash

set -e

echo "==============================="
echo "  INSTALADOR DE ENTORNO ARCH  "
echo "==============================="

PACMAN_LIST="appPacman.txt"
YAY_LIST="appYay.txt"
DOTFILES_DIR="$HOME/.dotfiles"
CONFIG_DIR="$HOME/.config"

########################################
# 1. Instalar paquetes de Pacman
########################################
if [ -f "$PACMAN_LIST" ]; then
    echo "📦 Instalando paquetes de Pacman..."

    while read -r pkg; do
        echo "→ $pkg"
        sudo pacman -S --needed --noconfirm "$pkg" || echo "❌ Falló $pkg"
    done < <(grep -vE '^\s*#|^\s*$' "$PACMAN_LIST")

else
    echo "⚠️  No se encontró $PACMAN_LIST"
fi

########################################
# 2. Instalar yay si no existe
########################################
if ! command -v yay &> /dev/null; then
    echo "🔧 Instalando yay (AUR helper)..."
    sudo pacman -S --needed git base-devel --noconfirm
    git clone https://aur.archlinux.org/yay.git
    cd yay && makepkg -si --noconfirm
    cd ..
    rm -rf yay
fi

########################################
# 3. Instalar paquetes AUR
########################################
if [ -f "$YAY_LIST" ]; then
    echo "📦 Instalando paquetes de AUR..."

    while read -r pkg; do
        echo "→ $pkg"
        yay -S --needed --noconfirm "$pkg" || echo "❌ Falló $pkg"
    done < <(grep -vE '^\s*#|^\s*$' "$YAY_LIST")

else
    echo "⚠️  No se encontró $YAY_LIST"
fi

########################################
# 4. Aplicar dotfiles (reemplazo total real)
########################################
echo "🎨 Aplicando dotfiles (reemplazo total)"

DIRS=("fastfetch" "hypr" "kitty" "ranger" "rofi" "waybar")

for dir in "${DIRS[@]}"; do
    SRC="$DOTFILES_DIR/$dir"
    DEST="$CONFIG_DIR/$dir"

    if [ -d "$SRC" ]; then
        echo "→ Reemplazando $dir"
        rm -rf "$DEST"
        cp -r "$SRC" "$CONFIG_DIR/"
    else
        echo "⚠️  $dir no existe en ~/.dotfiles"
    fi
done

echo "✔ Dotfiles aplicados correctamente"
echo "✅ Instalación completa. Reinicia sesión para ver los cambios."
