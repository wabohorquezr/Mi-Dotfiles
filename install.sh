#!/bin/bash

set -e

REPO="https://github.com/wabohorquezr/Mi-Dotfiles.git"
TMP_DIR="/tmp/mis-dotfiles"

# --- Clonar el repositorio primero ---
echo "Clonando repositorio..."
rm -rf "$TMP_DIR"
git clone "$REPO" "$TMP_DIR"

# --- Ejecutar la instalación de paquetes con apps.sh ---
if [ -f "$TMP_DIR/apps.sh" ]; then
    echo "Ejecutando script de instalación de aplicaciones (apps.sh)..."
    chmod +x "$TMP_DIR/apps.sh"
    bash "$TMP_DIR/apps.sh"
else
    echo "Error: No se encontró apps.sh en el repositorio."
    exit 1
fi


echo "Creando directorios en .config"

mkdir -p ~/.config/hypr
mkdir -p ~/.config/kitty
mkdir -p ~/.config/ranger
mkdir -p ~/.config/rofi
mkdir -p ~/.config/waybar

echo "Limpieza..."


rsync -av --delete "$TMP_DIR/config/hypr/" ~/.config/hypr/
rsync -av --delete "$TMP_DIR/config/kitty/" ~/.config/kitty/
rsync -av --delete "$TMP_DIR/config/ranger/" ~/.config/ranger/
rsync -av --delete "$TMP_DIR/config/rofi/" ~/.config/rofi/
rsync -av --delete "$TMP_DIR/config/waybar/" ~/.config/waybar/



echo "Instalación de Directorios completada."



echo "Instalando dependencias yay..."
sudo pacman -S --needed git base-devel

if ! command -v yay >/dev/null 2>&1; then
    echo "Instalando yay..."

    TMP_DIR_YAY="/tmp/yay"

    rm -rf "$TMP_DIR_YAY"
    git clone https://aur.archlinux.org/yay.git "$TMP_DIR_YAY"

    cd "$TMP_DIR_YAY"
    makepkg -si --noconfirm

    cd ~
    rm -rf "$TMP_DIR_YAY"
fi

echo "Instalando apss yay..."

PKGSYAY=(
    zen-browser-bin
    ltspice
    )

sudo pacman -S xdg-user-dirs
xdg-user-dirs-update
git clone https://github.com/NvChad/starter ~/.config/nvim && nvim


yay -S --needed --noconfirm "${PKGSYAY[@]}"


echo "Zen Browser instalado correctamente."

mkdir -p ~/Pictures/.wallpaper

rsync -av --delete "$TMP_DIR/config/wallpaper/" ~/Pictures/.wallpaper/

echo "Limpieza..."
rm -rf "$TMP_DIR"

chmod +x ~/.config/rofi/scripts/wallpaper.sh

echo "==> Creando directorio para capturas de pantalla..."
mkdir -p "$HOME/Pictures/Screenshots"

chmod +x "$HOME/.config/ranger/scope.sh"


# --- Instalación del Cursor Oreo ---
echo "Instalando tema de cursor Oreo..."
mkdir -p "$HOME/.local/share/icons"

TMP_OREO="/tmp/oreo-cursors"
rm -rf "$TMP_OREO"

# Clonación rápida del repositorio
git clone --depth 1 https://github.com/varlesh/oreo-cursors.git "$TMP_OREO"

# Copiar todas las variantes de Oreo disponibles en dist/
if [ -d "$TMP_OREO/dist" ]; then
    cp -r "$TMP_OREO"/dist/* "$HOME/.local/share/icons/"
else
    # Respaldo por si los archivos están en la raíz
    cp -r "$TMP_OREO"/oreo_* "$HOME/.local/share/icons/" 2>/dev/null || true
fi

# Limpieza
rm -rf "$TMP_OREO"

echo "Cursor Oreo instalado en ~/.local/share/icons/"

chsh -s "$(which zsh)"
