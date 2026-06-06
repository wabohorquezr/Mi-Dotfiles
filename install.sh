#!/bin/bash


PKGS=(
    waybar
    rofi
    kitty
    git
    rsync
    julia
    neovim
    octave
    impala
    bluetui
    network-manager-applet
    brightnessctl
    awww
    ttf-jetbrains-mono-nerd
    zsh
)
echo "Instalando paquetes..."


sudo pacman -Syu --needed "${PKGS[@]}"

echo "Instalación completada."

chsh -s "$(which zsh)"

echo "Zsh instalado."

#Repositorio

REPO="https://github.com/wabohorquezr/Mi-Dotfiles.git"
TMP_DIR="/tmp/mis-dotfiles"

echo "Clonando repositorio..."
git clone "$REPO" "$TMP_DIR"

echo "Creando directorios en .config"

mkdir -p ~/.config/hypr
mkdir -p ~/.config/kitty
mkdir -p ~/.config/ranger
mkdir -p ~/.config/rofi

echo "Limpieza..."


rsync -av --delete "$TMP_DIR/hypr/" ~/.config/hypr/
rsync -av --delete "$TMP_DIR/kitty/" ~/.config/kitty/
rsync -av --delete "$TMP_DIR/ranger/" ~/.config/ranger/
rsync -av --delete "$TMP_DIR/rofi/" ~/.config/rofi/

echo "Limpieza..."
rm -rf "$TMP_DIR"

echo "Instalación completada."
