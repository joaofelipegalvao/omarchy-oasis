#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
THEMES_DIR="$(dirname "$SCRIPT_DIR")/themes"
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
OMARCHY_THEMES="$CONFIG_HOME/omarchy/themes"
BACKUP_DIR="$HOME/.config/omarchy-backup-$(date +%Y%m%d-%H%M%S)"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

uninstall_theme() {
    local theme="$1"
    local target_dir="$OMARCHY_THEMES/oasis-$theme"

    if [ ! -d "$target_dir" ]; then
        echo -e "${RED}Error: Theme 'oasis-$theme' not installed${NC}"
        return 1
    fi

    echo -e "${YELLOW}Uninstalling theme: oasis-$theme${NC}"
    echo -e "${YELLOW}Backup location: $BACKUP_DIR${NC}"

    mkdir -p "$BACKUP_DIR"

    local removed=0

    for file in "$target_dir"/*; do
        if [ -f "$file" ]; then
            local basename=$(basename "$file")
            local dest_file=""

            case "$basename" in
                hyprland.conf)      dest_file="$CONFIG_HOME/hyprland.conf" ;;
                waybar.css)         dest_file="$CONFIG_HOME/waybar.css" ;;
                alacritty.toml)     dest_file="$CONFIG_HOME/alacritty.toml" ;;
                ghostty.conf)       dest_file="$CONFIG_HOME/ghostty.conf" ;;
                kitty.conf)         dest_file="$CONFIG_HOME/kitty.conf" ;;
                mako.ini)           dest_file="$CONFIG_HOME/mako.ini" ;;
                neovim.lua)         dest_file="$CONFIG_HOME/nvim/lua/user/colorscheme.lua" ;;
                hyprlock.conf)      dest_file="$CONFIG_HOME/hyprlock.conf" ;;
                btop.theme)         dest_file="$CONFIG_HOME/btop/themes/btop.theme" ;;
                chromium.theme)     dest_file="$CONFIG_HOME/chromium/chromium.theme" ;;
                icons.theme)        dest_file="$CONFIG_HOME/icons/icons.theme" ;;
                swayosd.css)        dest_file="$CONFIG_HOME/swayosd.css" ;;
                walker.css)         dest_file="$CONFIG_HOME/walker.css" ;;
                vscode.json)        dest_file="$CONFIG_HOME/Code - OSS/User/snippets/vscode.json" ;;
            esac

            if [ -n "$dest_file" ] && [ -f "$dest_file" ]; then
                mkdir -p "$(dirname "$dest_file")"
                cp "$dest_file" "$BACKUP_DIR/" 2>/dev/null || true
                rm -f "$dest_file"
                echo -e "  ${GREEN}✓${NC} $basename (backed up)"
                removed=$((removed + 1))
            fi
        elif [ -d "$file" ] && [ "$(basename "$file")" = "backgrounds" ]; then
            rm -rf "$file"
            echo -e "  ${GREEN}✓${NC} backgrounds"
        fi
    done

    rm -rf "$target_dir"
    echo -e "  ${GREEN}✓${NC} Removed $target_dir"

    if [ $removed -eq 0 ]; then
        echo ""
        echo -e "${YELLOW}No configs found in ~/.config/${NC}"
        rm -rf "$BACKUP_DIR"
    else
        echo ""
        echo -e "${GREEN}Theme 'oasis-$theme' uninstalled!${NC}"
        echo -e "${YELLOW}Backup location: $BACKUP_DIR${NC}"
    fi
}

interactive_uninstall() {
    local installed_themes=($(ls -d "$OMARCHY_THEMES"/oasis-*/ 2>/dev/null | xargs -I {} basename {} | sed 's/oasis-//' | sort))
    local total=${#installed_themes[@]}

    if [ $total -eq 0 ]; then
        echo -e "${RED}No themes installed${NC}"
        exit 1
    fi

    echo -e "${RED}╔══════════════════════════════════════════╗${NC}"
    echo -e "${RED}║   Omarchy Oasis - Theme Uninstaller     ║${NC}"
    echo -e "${RED}╚══════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}WARNING: This will remove configs and create backups!${NC}"
    echo ""
    echo "Installed themes:"
    echo ""

    for i in "${!installed_themes[@]}"; do
        local idx=$((i + 1))
        local theme="${installed_themes[$i]}"
        echo -e "  ${RED}$idx)${NC} $theme"
    done

    echo ""
    echo -e "${RED}q)${NC} Quit"
    echo ""
    read -p "Select theme to uninstall: " choice

    if [ "$choice" = "q" ] || [ "$choice" = "Q" ]; then
        echo "Cancelled."
        exit 0
    fi

    if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le $total ]; then
        local theme="${installed_themes[$((choice - 1))]}"
        read -p "Uninstall 'oasis-$theme'? This will backup your configs. [y/N] " confirm
        if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
            uninstall_theme "$theme"
        else
            echo "Cancelled."
        fi
    else
        echo -e "${RED}Invalid selection${NC}"
        exit 1
    fi
}

show_usage() {
    echo "Usage: $0 [theme_name]"
    echo ""
    echo "Arguments:"
    echo "  theme_name    Uninstall specific theme (e.g., abyss, starlight)"
    echo "  (none)        Run interactive uninstaller"
    echo ""
    echo "Note: Configs are backed up to ~/.config/omarchy-backup-TIMESTAMP/"
    echo ""
    echo "Installed themes:"
    for theme in $(ls -d "$OMARCHY_THEMES"/oasis-*/ 2>/dev/null | xargs -I {} basename {} | sed 's/oasis-//' | sort); do
        echo "  - $theme"
    done
}

main() {
    if [ $# -eq 0 ]; then
        interactive_uninstall
    else
        case "$1" in
            -h|--help)
                show_usage
                exit 0
                ;;
            *)
                read -p "Uninstall 'oasis-$1'? This will backup your configs. [y/N] " confirm
                if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
                    uninstall_theme "$1"
                else
                    echo "Cancelled."
                fi
                ;;
        esac
    fi
}

main "$@"
