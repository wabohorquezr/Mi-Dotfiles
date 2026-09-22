

#!/bin/bash

PKGS=(
    zsh
    rsync
    ark
    brightnessctl
    cliphist
    discord
    efibootmgr
    git
    graphviz                 # Contiene dot
    grim
    grub
    gtkwave
    icestorm                 # Contiene iceprog
    inkscape
    iverilog
    jq
    julia
    kitty
    libnotify
    lite-xl
    mako
    neovim
    network-manager-applet
    nextpnr                  # Contiene nextpnr-ice40
    ngspice
    ntfs-3g
    octave
    openfpgaloader           # Para openFPGALoader
    os-prober
    p7zip
    picocom
    pulseview
    python-pillow
    ranger
    riscv64-elf-gcc          # Toolchain RISC-V (nombre oficial en Arch)
    rofi
    rsync
    slurp
    ttf-jetbrains-mono-nerd
    unrar
    unzip
    verilator
    vlc
    waybar
    wl-clipboard
    yosys
    zathura-pdf-mupdf
)
echo "Instalando paquetes..."

sudo pacman -Syu --needed "${PKGS[@]}"

echo "Instalación completada."
