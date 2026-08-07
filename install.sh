#!/bin/bash

# Terminar el script si ocurre algún error
set -e

# ==========================================
# VARIABLES GLOBALES
# ==========================================
REPO="https://github.com/wabohorquezr/Mi-Dotfiles.git"
TMP_DIR="/tmp/mis-dotfiles"


# ==========================================
# 1. FUNCIONES DE INSTALACIÓN
# ==========================================

preparar_repositorio() {
    echo "==> Clonando repositorio..."
    rm -rf "$TMP_DIR"
    git clone "$REPO" "$TMP_DIR"
}

instalar_paquetes_base() {
    if [ -f "$TMP_DIR/apps.sh" ]; then
        echo "==> Ejecutando script de instalación de aplicaciones (apps.sh)..."
        chmod +x "$TMP_DIR/apps.sh"
        bash "$TMP_DIR/apps.sh"
    else
        echo "Error: No se encontró apps.sh en el repositorio."
        exit 1
    fi
}

desplegar_configuraciones() {
    echo "==> Creando directorios y copiando configuraciones..."
    mkdir -p ~/.config/{hypr,kitty,ranger,rofi,waybar}
    mkdir -p ~/Pictures/.wallpaper
    mkdir -p "$HOME/Pictures/Screenshots"

    # rsync -a hace lo mismo que -av, pero de forma silenciosa para no saturar la terminal
    rsync -a --delete "$TMP_DIR/config/hypr/" ~/.config/hypr/
    rsync -a --delete "$TMP_DIR/config/kitty/" ~/.config/kitty/
    rsync -a --delete "$TMP_DIR/config/ranger/" ~/.config/ranger/
    rsync -a --delete "$TMP_DIR/config/rofi/" ~/.config/rofi/
    rsync -a --delete "$TMP_DIR/config/waybar/" ~/.config/waybar/
    rsync -a --delete "$TMP_DIR/config/wallpaper/" ~/Pictures/.wallpaper/

    echo "==> Asignando permisos de ejecución..."
    chmod +x ~/.config/rofi/scripts/wallpaper.sh
    chmod +x "$HOME/.config/ranger/scope.sh"
}

instalar_entorno_aur() {
    echo "==> Configurando directorios de usuario (xdg-user-dirs)..."
    sudo pacman -S --needed --noconfirm xdg-user-dirs
    xdg-user-dirs-update

    echo "==> Instalando dependencias base-devel y yay..."
    sudo pacman -S --needed --noconfirm git base-devel

    if ! command -v yay >/dev/null 2>&1; then
        echo "--> Instalando yay..."
        TMP_DIR_YAY="/tmp/yay"
        rm -rf "$TMP_DIR_YAY"
        git clone https://aur.archlinux.org/yay.git "$TMP_DIR_YAY"
        (cd "$TMP_DIR_YAY" && makepkg -si --noconfirm)
        rm -rf "$TMP_DIR_YAY"
    fi

    echo "==> Instalando apps de AUR..."
    PKGSYAY=(
        zen-browser-bin
        ltspice
    )
    yay -S --needed --noconfirm "${PKGSYAY[@]}"
    echo "--> Aplicaciones de AUR instaladas correctamente."
}

instalar_nvchad() {
    if [ ! -d "$HOME/.config/nvim" ]; then
        echo "==> Instalando NvChad (Neovim)..."
        git clone https://github.com/NvChad/starter ~/.config/nvim
    else
        echo "--> NvChad ya está instalado."
    fi
}

instalar_cursores() {
    echo "==> Instalando tema de cursor Oreo (Pre-compilado)..."
    mkdir -p "$HOME/.local/share/icons"

    TMP_OREO="/tmp/oreo-cursors"
    rm -rf "$TMP_OREO"

    git clone --depth 1 https://github.com/milkmadedev/oreo-cursors-compiled.git "$TMP_OREO"
    cp -r "$TMP_OREO"/oreo_* "$HOME/.local/share/icons/"
    rm -rf "$TMP_OREO"

    echo "--> Cursores Oreo instalados exitosamente."
}

configurar_shell() {
    echo "==> Cambiando shell predeterminada a Zsh..."
    chsh -s "$(which zsh)"
}

limpiar_sistema() {
    echo "==> Limpieza final..."
    rm -rf "$TMP_DIR"
    echo -e "\n================================================="
    echo " ¡Instalación de Dotfiles completada con éxito!"
    echo "================================================="
}

configurar_grub() {
    echo "==> Configurando GRUB para Dual-Boot (Universal y Forzado a UEFI)..."
    
    # 1. Instalar dependencias (se añade grub y efibootmgr para la instalación UEFI)
    sudo pacman -S --needed --noconfirm grub efibootmgr os-prober ntfs-3g

    # 2. Forzar instalación de GRUB en modo UEFI en la partición /boot
    echo "==> Instalando GRUB en la partición EFI..."
    sudo grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB

    # 3. Habilitar os-prober en /etc/default/grub
    if grep -q "^#GRUB_DISABLE_OS_PROBER=false" /etc/default/grub; then
        sudo sed -i 's/^#GRUB_DISABLE_OS_PROBER=false/GRUB_DISABLE_OS_PROBER=false/' /etc/default/grub
    elif ! grep -q "^GRUB_DISABLE_OS_PROBER=false" /etc/default/grub; then
        echo "GRUB_DISABLE_OS_PROBER=false" | sudo tee -a /etc/default/grub
    fi

    # 4. Intentar generar GRUB normalmente
    echo "==> Escaneando sistemas operativos..."
    sudo grub-mkconfig -o /boot/grub/grub.cfg > /tmp/grub_output.txt 2>&1

    # 5. Verificar si os-prober falló al detectar Windows
    if ! grep -iq "Windows" /tmp/grub_output.txt; then
        echo "--> os-prober no detectó Windows. Buscando partición EFI manualmente..."
        
        WIN_UUID=""
        sudo mkdir -p /tmp/efi_scan
        
        # Escanear todas las particiones vfat (FAT32) en todos los discos
        for part in $(lsblk -lno PATH,FSTYPE | grep -i 'vfat' | awk '{print $1}'); do
            mounted=false
            
            # Si no está montada, la montamos temporalmente
            if ! grep -q "^$part " /proc/mounts; then
                sudo mount -o ro "$part" /tmp/efi_scan 2>/dev/null
                mounted=true
                scan_dir="/tmp/efi_scan"
            else
                # Si ya está montada, leemos su ruta
                scan_dir=$(lsblk -lno MOUNTPOINT "$part" | grep -v "^$")
            fi
            
            # Buscar el archivo exacto de arranque de Windows
            if [ -f "$scan_dir/EFI/Microsoft/Boot/bootmgfw.efi" ] || [ -f "$scan_dir/efi/microsoft/boot/bootmgfw.efi" ]; then
                WIN_UUID=$(sudo blkid -s UUID -o value "$part")
                echo "--> ¡Windows encontrado en $part con UUID: $WIN_UUID!"
                
                if [ "$mounted" = true ]; then
                    sudo umount /tmp/efi_scan 2>/dev/null
                fi
                break
            fi
            
            if [ "$mounted" = true ]; then
                sudo umount /tmp/efi_scan 2>/dev/null
            fi
        done
        
        sudo rm -rf /tmp/efi_scan

        # 6. Inyectar Windows si se encontró el UUID
        if [ -n "$WIN_UUID" ]; then
            echo "==> Inyectando entrada manual para Windows en GRUB..."
            
            # Limpiar entradas previas en 40_custom para no duplicarlas
            sudo sed -i '/menuentry "Windows 10/,/}/d' /etc/grub.d/40_custom
            
            # Escribir la nueva entrada con el UUID detectado automáticamente
            cat <<EOF | sudo tee -a /etc/grub.d/40_custom
menuentry "Windows 10" {
    insmod part_gpt
    insmod fat
    insmod chain
    search --no-floppy --fs-uuid --set=root $WIN_UUID
    chainloader /EFI/Microsoft/Boot/bootmgfw.efi
}
EOF
            # Regenerar GRUB para aplicar la entrada inyectada
            sudo grub-mkconfig -o /boot/grub/grub.cfg > /dev/null 2>&1
            echo "--> Entrada manual creada y aplicada con éxito."
        else
            echo "--> No se encontró ninguna instalación de Windows en este equipo."
        fi
    else
        echo "--> os-prober detectó Windows exitosamente."
    fi
    
    rm -f /tmp/grub_output.txt
    echo "==> GRUB configurado con éxito en modo UEFI."
}

# ==========================================
# 2. EJECUCIÓN PRINCIPAL (PANEL DE CONTROL)
# ==========================================
# Si quieres omitir un paso (por ejemplo, los cursores),
# simplemente pon un '#' al inicio de esa línea.

preparar_repositorio
instalar_paquetes_base
desplegar_configuraciones
instalar_entorno_aur
instalar_nvchad
instalar_cursores
configurar_grub
configurar_shell
limpiar_sistema
