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


# 5. Configurar los dotfiles (Evitando conflictos)
echo "Configurando archivos en ~/.config..."

# Creamos la carpeta .config por si no existe
mkdir -p ~/.config

# Lista de carpetas que vas a mover (añade las que necesites)
CONFIG_DIRS=("fastfetch" "hypr" "kitty" "ranger" "rofi" "waybar")

for dir in "${CONFIG_DIRS[@]}"; do
    if [ -d "$HOME/.config/$dir" ]; then
        echo "Resguardando configuración existente de $dir en $dir.bak"
        # Borra el backup anterior si existe y crea uno nuevo
        rm -rf "$HOME/.config/$dir.bak"
        mv "$HOME/.config/$dir" "$HOME/.config/$dir.bak"
    fi
    
    # Copia limpia desde tu carpeta de git a .config
    echo "Instalando nueva config para $dir..."
    cp -r "./config/$dir" "$HOME/.config/"
done

echo "¡Configuraciones aplicadas sin conflictos!"


echo "¡Instalación completa! Reinicia para ver los cambios."
