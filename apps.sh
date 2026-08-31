

#!/bin/bash

PKGS=(
    python-pillow
    ranger
    zsh
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
    cliphist
    waybar
    rofi
    kitty
    git
    rsync
    julia
    inkscape
    neovim
    octave
    impala
    bluetui
    ark 
    unzip
    unrar
    p7zip
    network-manager-applet
    brightnessctl
    awww
    ttf-jetbrains-mono-nerd
)
echo "Instalando paquetes..."

sudo pacman -Syu --needed "${PKGS[@]}"

echo "Instalación completada."
