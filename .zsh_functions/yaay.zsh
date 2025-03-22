# Wrapper for yay with convenient shortcuts
function yaay() {
    # Sudo session management
    _sudo_init() {
        sudo -v
        while true; do
            sudo -n true
            sleep 60
            kill -0 "$$" || exit
        done 2>/dev/null &
    }

    _sudo_cleanup() {
        sudo -k
    }

    _sudo() {
        sudo --prompt="" "$@"
    }

    trap '_sudo_cleanup' EXIT
    local START_TIME=$SECONDS

    if [[ -z $1 ]]; then
        _sudo_init
        echo "🚀 Starting full system update..."

        # Mirror updates
        local MIRROR_FILE="$HOME/.cache/yaay_mirror_last_updated"
        local LAST_UPDATED=$(( $(date +%s) - 1209600 ))  # 14 days in seconds
        
        if [[ ! -f $MIRROR_FILE || $(stat -c %Y $MIRROR_FILE) -lt $LAST_UPDATED ]]; then
            if command -v reflector &>/dev/null; then
                echo "\n🪞 Optimizing mirrors..."
                _sudo reflector --latest 5 --sort rate --save /etc/pacman.d/mirrorlist
                touch $MIRROR_FILE
            else
                echo "ℹ️ Install reflector for optimized mirrors: yaay reflector"
            fi
        else
            echo "\n⏭️ Mirror update skipped (updated within last 14 days)"
        fi

        # Core updates
        echo "\n📦 System packages:"
        if ! _sudo pacman -Syu --noconfirm; then
            echo "❗ System update failed"
            return 1
        fi
        
        echo "\n🌈 AUR packages:"
        if ! yay -Syu --noconfirm; then
            echo "\n⚠️  Some AUR packages failed to update (continuing)"
            sleep 2
        fi
        
        echo "\n📦 Flatpak updates:"
        if command -v flatpak &>/dev/null; then
            flatpak update -y
        else
            echo "➡️ Install Flatpak: yaay flatpak"
        fi

        # Cleanup
        echo "\n🧹 Maintenance:"
        _sudo paccache -r
        yay -Sc --noconfirm
        yeet orphans
        flatpak uninstall --unused

        # Firmware
        echo "\n🔌 Firmware:"
                fwupdmgr refresh
                fwupdmgr update


        # Post-update system insights
        echo "\n🔍 System Status Report:"    
      
        # AUR packages
        echo "\n🌈 AUR package status:"
        
        # Check for packages missing from AUR
        local AUR_PKGS=($(pacman -Qm | awk '{print $1}'))
        local MISSING_IN_AUR=()
        for pkg in "${AUR_PKGS[@]}"; do
            yay -Si "$pkg" &>/dev/null || MISSING_IN_AUR+=("$pkg")
        done
        
        # Show missing packages if any
        if [[ ${#MISSING_IN_AUR[@]} -gt 0 ]]; then
            echo "-> Packages not in AUR: ${MISSING_IN_AUR[*]}"
        fi
        
        # Show other yay statuses
        yay -Ps | awk '/-> (Orphan \(unmaintained\) AUR Packages|Flagged Out Of Date AUR Packages)/'
        
        # Config files
        echo "\n📄 Configuration updates needed (.pacnew/.pacsave):"
        local CONFIG_FILES=$(_sudo find /etc -name '*.pacnew' -o -name '*.pacsave' 2>/dev/null)
        if [[ -n $CONFIG_FILES ]]; then
            echo "$CONFIG_FILES"
            echo "\nℹ️ Review these files with:\n   sudo diff <file> <file.pacnew>"
        else
            echo "None found"
        fi

        echo "\n✅ All updates completed!"

        # Execution time
        local DURATION=$((SECONDS - START_TIME))
        echo "⏱️ Update completed in ${DURATION} seconds"

    elif [[ $1 == "find" ]]; then
        yay -Ss "${@:2}"
    elif [[ $1 == "list" ]]; then
        case $2 in
            aur)  # List AUR installed packages
                echo "🌌 AUR packages ($(pacman -Qm | wc -l)):"
                pacman -Qm
                ;;
            updates)  # List updatable packages
                echo "🔄 Available updates ($(yay -Qua | wc -l)):"
                yay -Qua
                ;;
            installed)
                echo "📦 Installed packages ($(pacman -Q | wc -l)):"
                pacman -Q | awk '{printf "%-30s %s\n", $1, $2}' | column -t
                ;;
            explicit)  # List explicitly installed packages (not as dependencies)
                echo "📌 Explicitly installed:"
                pacman -Qeq | awk '{printf "%-30s\n", $1}' | column -c $(tput cols)
                ;;
            recent)
                echo "🕒 Recently installed ($(expac --timefmt='%F %T' '%l\t%n' | sort -r | head -n30 | wc -l)):"
                expac --timefmt='%F %T' '%l\t%n' | sort -r | head -n30 | cut -f2
                ;;
            large)
                echo "🏋️ Large packages ($(expac -H M '%-30n %m' | sort -hrk2 | head -n20 | wc -l)):"
                expac -H M '%-30n %m' | sort -hrk2 | head -n20
                ;;
            *)  # Default case to help with usage
                echo "Usage: yaay list [updates|installed|explicit|aur|recent|large]"
                return 1
                ;;
        esac
    else
        yay -S "$@"
    fi
}

# Wrapper for removing packages with yay
function yeet() {
    if [[ -z $1 ]]; then
        echo "Usage: yeet [pkgname|orphans]"
        return 1
    elif [[ $1 == "orphans" ]]; then
        # Find orphaned packages
        local orphans=$(_sudo pacman -Qtdq)
        if [[ -z $orphans ]]; then
            echo "No orphans. Wait for abandonment."
            return 0
        else
            # Remove orphaned packages
            echo "$orphans" | _sudo pacman -Rns -
        fi
    else
        yay -Rns "$@"
    fi
}
