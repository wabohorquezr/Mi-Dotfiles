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
# 4. Aplicar dotfiles (detecta estructura automáticamente)
########################################
echo "🎨 Aplicando dotfiles (detección automática)"

DOTFILES_DIR="$HOME/.dotfiles"
CONFIG_DIR="$HOME/.config"

# Detectar dónde está realmente la carpeta .config dentro del repo
if [ -d "$DOTFILES_DIR/.config" ]; then
    BASE="$DOTFILES_DIR/.config"
elif [ -d "$DOTFILES_DIR/home/$USER/.config" ]; then
    BASE="$DOTFILES_DIR/home/$USER/.config"
else
    BASE="$DOTFILES_DIR"
fi

echo "📁 Usando dotfiles desde: $BASE"

DIRS=("fastfetch" "hypr" "kitty" "ranger" "rofi" "waybar")

for dir in "${DIRS[@]}"; do
    SRC="$BASE/$dir"
    DEST="$CONFIG_DIR/$dir"

    if [ -d "$SRC" ]; then
        echo "→ Reemplazando $dir"
        rm -rf "$DEST"
        cp -r "$SRC" "$CONFIG_DIR/"
    else
        echo "⚠️  $dir no existe en $BASE"
    fi
done

hyprctl reload

########################################
# 5. Extras → Pictures
########################################
echo "🖼️  Moviendo extras a ~/Pictures"

DOTFILES_DIR="$HOME/.dotfiles"
PICTURES_DIR="$HOME/Pictures"
EXTRAS_DIR="$DOTFILES_DIR/.extras"

mkdir -p "$PICTURES_DIR"

for extra in ".Wallpaper" ".fastfetch_vault"; do
    SRC="$EXTRAS_DIR/$extra"
    DEST="$PICTURES_DIR/$extra"

    if [ -d "$SRC" ]; then
        echo "→ Moviendo $extra a Pictures"
        rm -rf "$DEST"
        mv "$SRC" "$PICTURES_DIR/"
    else
        echo "⚠️  $extra no existe en .extras"
    fi
done

echo "✔ Extras movidos correctamente"

########################################
# 6. Configurar ZSH y Oh My Zsh
echo "Configurando ZSH..."
########################################
# Instalar zsh si no está (por si no estaba en tus listas de pacman)
sudo pacman -S --needed zsh --noconfirm

# Instalar Oh My Zsh de forma no interactiva
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Instalando Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "Oh My Zsh ya está instalado."
fi

# Cambiar el shell por defecto a zsh
if [ "$SHELL" != "/usr/bin/zsh" ]; then
    echo "Cambiando el shell predeterminado a ZSH..."
    chsh -s $(which zsh)
fi

# 7. Personalizar .zshrc (Tema bira y Fastfetch)
echo "Personalizando .zshrc..."

# Cambiar el tema a 'bira'
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="bira"/' "$HOME/.zshrc"

# Añadir fastfetch al final si no existe ya
if ! grep -q "fastfetch" "$HOME/.zshrc"; then
    echo -e "\n# Mostrar info del sistema al abrir terminal\nfastfetch" >> "$HOME/.zshrc"
fi

########################################
# 7. .zshrc → HOME (reemplazo si existe)
########################################

DOTFILES_DIR="$HOME/.dotfiles"

for path in \
    "$DOTFILES_DIR/.zshrc" \
    "$DOTFILES_DIR/.config/.zshrc" \
    "$DOTFILES_DIR/home/$USER/.zshrc"
do
    if [ -f "$path" ]; then
        rm -f "$HOME/.zshrc"
        cp "$path" "$HOME/.zshrc"
        break
    fi
done


echo "¡ZSH configurado con éxito!"


echo "✔ Dotfiles aplicados correctamente"
