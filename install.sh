#!/bin/bash

set -e

PKGS=(
    cliphist
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
    ranger
)

echo "Instalando paquetes..."

sudo pacman -Syu --needed "${PKGS[@]}"

echo "Instalación completada."


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

chsh -s "$(which zsh)"
