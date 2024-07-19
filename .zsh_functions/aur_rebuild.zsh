aur_rebuild() {
    if command -v checkrebuild &>/dev/null; then
        echo "Checking for packages that might need a rebuild..."
        potentially_broken_packages=$(checkrebuild -v | grep -Eo '^[a-zA-Z0-9._+-]+')

        if [[ -n "$potentially_broken_packages" ]]; then
            echo "The following packages might need a rebuild:"
            echo "$potentially_broken_packages"
            echo "Attempting to rebuild..."

            echo "$potentially_broken_packages" | while read -r pkg; do
                if ! yay -S --rebuild "$pkg"; then
                    echo "Failed to rebuild $pkg. Manual intervention required."
                fi
            done
        else
            echo "All packages seem fine."
        fi
    else
        echo "checkrebuild not found. Consider installing it to check for packages that might need a rebuild."
    fi
}

