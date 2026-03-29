#!/bin/bash

# 1. Actualizar el sistema primero
echo "Actualizando el sistema..."

mapfile -t PKGS < <(grep -vE '^\s*#|^\s*$' appPacman.txt)
sudo pacman -S --needed --noconfirm "${PKGS[@]}"

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

mkdir -p "$CONFIG"

DIRS=("fastfetch" "hypr" "kitty" "ranger" "rofi" "waybar")

for dir in "${DIRS[@]}"; do
    SRC="$DOTFILES/$dir/"
    DEST="$CONFIG/$dir/"

    if [ -d "$SRC" ]; then
        echo "→ Reemplazando $dir"

        mkdir -p "$DEST"

        rsync -a --delete "$SRC" "$DEST"
    else
        echo "⚠️  $dir no existe en ~/.dotfiles"
    fi
done

echo "✔ Dotfiles sincronizados exactamente al repo"

echo "¡Configuraciones aplicadas sin conflictos!"


echo "¡Instalación completa! Reinicia para ver los cambios."
