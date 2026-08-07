

#!/bin/bash

PKGS=(
    grub
    efibootmgr
    os-prober
    ntfs-3g
    grim 
    slurp 
    jq 
    mako 
    libnotify
    zathura-pdf-mupdf
    vlc
    wl-clipboard
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
)
echo "Instalando paquetes..."

sudo pacman -Syu --needed "${PKGS[@]}"

echo "Instalación completada."
