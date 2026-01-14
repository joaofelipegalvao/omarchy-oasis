#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEMES_DIR="$SCRIPT_DIR/themes"
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
BACKUP_DIR="$HOME/.config/omarchy-backup-$(date +%Y%m%d-%H%M%S)"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

uninstall_theme() {
    local theme="$1"
    local theme_path="$THEMES_DIR/$theme"

    if [ ! -d "$theme_path" ]; then
        echo -e "${RED}Error: Theme '$theme' not found${NC}"
        return 1
    fi

    echo -e "${YELLOW}Uninstalling theme: $theme${NC}"
    echo -e "${YELLOW}Backing up configs to: $BACKUP_DIR${NC}"

    mkdir -p "$BACKUP_DIR"

    local removed=0

    for item in "$theme_path"/*; do
        if [ -d "$item" ]; then
            local dirname=$(basename "$item")
            local target_dir="$CONFIG_HOME/$dirname"

            if [ -d "$target_dir" ]; then
                cp -r "$target_dir" "$BACKUP_DIR/" 2>/dev/null || true
                rm -rf "$target_dir"
                echo -e "  ${GREEN}✓${NC} $dirname (backed up to $BACKUP_DIR)"
                removed=$((removed + 1))
            fi
        elif [ -f "$item" ]; then
            local basename=$(basename "$item")
            local ext="${basename##*.}"
            local name="${basename%.*}"
            local target_file="$CONFIG_HOME/$basename"

            case "$ext" in
                theme)
                    local target_dir="$CONFIG_HOME/$name"
                    if [ -d "$target_dir" ] && [ -f "$target_dir/theme" ]; then
                        cp -r "$target_dir" "$BACKUP_DIR/" 2>/dev/null || true
                        rm -rf "$target_dir"
                        echo -e "  ${GREEN}✓${NC} $name.theme (backed up)"
                        removed=$((removed + 1))
                    fi
                    ;;
                conf|toml|ini|css|lua|json)
                    if [ -f "$target_file" ]; then
                        cp "$target_file" "$BACKUP_DIR/" 2>/dev/null || true
                        rm "$target_file"
                        echo -e "  ${GREEN}✓${NC} $basename (backed up)"
                        removed=$((removed + 1))
                    elif [ -f "$CONFIG_HOME/${name}.${ext}" ]; then
                        cp "$CONFIG_HOME/${name}.${ext}" "$BACKUP_DIR/" 2>/dev/null || true
                        rm "$CONFIG_HOME/${name}.${ext}"
                        echo -e "  ${GREEN}✓${NC} ${name}.${ext} (backed up)"
                        removed=$((removed + 1))
                    fi
                    ;;
            esac
        fi
    done

    local backgrounds_src="$theme_path/backgrounds"
    if [ -d "$backgrounds_src" ]; then
        local backgrounds_dst="$CONFIG_HOME/backgrounds"
        if [ -d "$backgrounds_dst" ]; then
            cp -r "$backgrounds_dst" "$BACKUP_DIR/" 2>/dev/null || true
            rm -rf "$backgrounds_dst"
            echo -e "  ${GREEN}✓${NC} backgrounds (backed up)"
            removed=$((removed + 1))
        fi
    fi

    if [ $removed -eq 0 ]; then
        echo -e "${YELLOW}No configs found for theme '$theme'${NC}"
        rm -rf "$BACKUP_DIR"
    else
        echo ""
        echo -e "${GREEN}Theme '$theme' uninstalled successfully!${NC}"
        echo -e "${YELLOW}Backup location: $BACKUP_DIR${NC}"
        echo -e "${YELLOW}Note: You may need to restart applications for changes to take effect.${NC}"
    fi
}

interactive_uninstall() {
    local themes=($(ls -d "$THEMES_DIR"/*/ 2>/dev/null | xargs -I {} basename {} | sort))
    local total=${#themes[@]}

    if [ $total -eq 0 ]; then
        echo -e "${RED}No themes found in $THEMES_DIR${NC}"
        exit 1
    fi

    echo -e "${RED}╔══════════════════════════════════════════╗${NC}"
    echo -e "${RED}║   Omarchy Oasis - Theme Uninstaller     ║${NC}"
    echo -e "${RED}╚══════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}WARNING: This will remove configs and create backups!${NC}"
    echo ""
    echo "Select theme to uninstall:"
    echo ""

    for i in "${!themes[@]}"; do
        local idx=$((i + 1))
        local theme="${themes[$i]}"
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
        local theme="${themes[$((choice - 1))]}"
        read -p "Uninstall '$theme'? This will backup your configs. [y/N] " confirm
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
    echo "Available themes:"
    for theme in $(ls -d "$THEMES_DIR"/*/ 2>/dev/null | xargs -I {} basename {} | sort); do
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
                read -p "Uninstall '$1'? This will backup your configs. [y/N] " confirm
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
