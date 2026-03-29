#!/bin/bash

# 1. Actualizar el sistema primero
echo "Actualizando el sistema..."
sudo pacman -Syu --noconfirm

# 2. Instalar desde Pacman (usando tu archivo .txt)
if [ -f "appPacman.txt" ]; then
    echo "Instalando aplicaciones de Pacman..."
    sudo pacman -S --needed --noconfirm - < appPacman.txt 
else
    echo "Error: No se encontró appPacman.txt"
fi

# 3. Asegurarse de que 'yay' esté instalado
if ! command -v yay &> /dev/null; then
    echo "Instalando yay (AUR helper)..."
    sudo pacman -S --needed git base-devel --noconfirm
    git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si --noconfirm && cd ..
fi

# 4. Instalar desde AUR (usando tu archivo .txt)
if [ -f "appYay.txt" ]; then
    echo "Instalando aplicaciones de AUR..."
    yay -S --needed --noconfirm - < appYay.txt
else
    echo "Error: No se encontró appYay.txt"
fi


#!/bin/bash

echo "Aplicando dotfiles desde ~/.dotfiles hacia ~/.config (reemplazo total)"

DOTFILES_DIR="$HOME/.dotfiles"
CONFIG_DIR="$HOME/.config"

mkdir -p "$CONFIG_DIR"

CONFIG_DIRS=("fastfetch" "hypr" "kitty" "ranger" "rofi" "waybar")

for dir in "${CONFIG_DIRS[@]}"; do
    SRC="$DOTFILES_DIR/$dir"
    DEST="$CONFIG_DIR/$dir"

    if [ -d "$SRC" ]; then
        echo "→ Reemplazando $dir"
        rm -rf "$DEST"
        cp -r "$SRC" "$CONFIG_DIR/"
    else
        echo "⚠️  $dir no existe en ~/.dotfiles, se omite"
    fi
done

echo "✔ Dotfiles aplicados correctamente"

echo "¡Configuraciones aplicadas sin conflictos!"


echo "¡Instalación completa! Reinicia para ver los cambios."
