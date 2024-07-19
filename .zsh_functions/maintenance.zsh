maintenance() {
    # Update mirrors for faster package downloads (optional)
    echo "Updating mirrors..."
    if command -v reflector &>/dev/null; then
        sudo reflector --verbose --latest 5 --sort rate --save /etc/pacman.d/mirrorlist
    else
        echo "reflector not found. Consider installing it for optimized mirrors."
    fi

    # Update and upgrade all packages
    echo "Updating and upgrading system..."
    sudo pacman -Syu --noconfirm

    # Update and upgrade AUR packages
    if command -v yay &>/dev/null; then
        echo "Updating and upgrading AUR packages..."
        yay -Syu --noconfirm
    else
        echo "yay not found. Consider installing it for AUR package management."
    fi

    # Update and upgrade Flatpak packages
    if command -v flatpak &>/dev/null; then
        echo "Updating and upgrading Flatpak packages..."
        sudo flatpak update -y
    else
        echo "flatpak not found. Consider installing it for Flatpak package management."
    fi

    # Clean out old packages from cache
    echo "Cleaning package cache..."
    sudo paccache -r

    # Remove unused packages (orphans)
    orphans=$(pacman -Qdtq)
    if [ "$orphans" ]; then
        echo "Removing orphaned packages..."
        sudo pacman -Rns --noconfirm $orphans
    else
        echo "No orphans to remove."
    fi

    # Clean AUR package cache
    if command -v yay &>/dev/null; then
        echo "Cleaning AUR package cache..."
        yay -Sc --noconfirm
    else
        echo "yay not found. Skipping AUR cache clean."
    fi

    # Finish
    echo "Maintenance done."
}
