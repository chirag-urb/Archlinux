# Wrapper for yay with convenient shortcuts
function yaay() {
    if [[ -z $1 ]]; then
        yay --noconfirm
        flatpak update -y
        fwupdmgr refresh
        fwupdmgr update
    elif [[ $1 == "find" ]]; then
        yay -Ss "${@:2}"
    elif [[ $1 == "list" ]]; then
        case $2 in
            aur)  # List AUR installed packages
                pacman -Qm
                ;;
            updates)  # List updatable packages
                paru -Qua  && checkupdates
                ;;
            installed)  # List all installed packages
                pacman -Q
                ;;
            explicit)  # List explicitly installed packages (not as dependencies)
                pacman -Qe
                ;;
            recent)  # List recently installed packages
                expac --timefmt='%Y-%m-%d %T' '%l\t%n' | sort | tail -n 30
                ;;
            large)  # List installed packages by size
                expac -H M '%-30n %m' | sort -h -k 2 | tail
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
        local orphans=$(sudo pacman -Qtdq)
        if [[ -z $orphans ]]; then
            echo "No orphans. Wait for abandonment."
            return 0
        else
            # Remove orphaned packages
            echo "$orphans" | sudo pacman -Rns -
        fi
    else
        yay -Rns "$@"
    fi
}
