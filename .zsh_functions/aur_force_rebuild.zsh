aur_force_rebuild() {
    # Fetch a list of all installed AUR packages
    aur_packages=$(pacman -Qm | awk '{print $1}')

    # Rebuild each AUR package using yay
    for pkg in $aur_packages; do
        if ! yay -S --noconfirm "$pkg"; then
            echo "Failed to rebuild $pkg. Manual intervention required."
        fi
    done
}

