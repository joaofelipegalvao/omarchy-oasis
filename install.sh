#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
THEMES_DIR="$SCRIPT_DIR/themes"
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

list_themes() {
    ls -d "$THEMES_DIR"/*/ 2>/dev/null | xargs -I {} basename {} | sort
}

show_preview() {
    local theme="$1"
    local preview_path="$THEMES_DIR/$theme/preview.png"
    if [ -f "$preview_path" ]; then
        echo -e "${YELLOW}Preview: $preview_path${NC}"
    fi
}

install_theme() {
    local theme="$1"
    local theme_path="$THEMES_DIR/$theme"

    if [ ! -d "$theme_path" ]; then
        echo -e "${RED}Error: Theme '$theme' not found${NC}"
        return 1
    fi

    echo -e "${GREEN}Installing theme: $theme${NC}"

    for item in "$theme_path"/*; do
        if [ -d "$item" ]; then
            local dirname=$(basename "$item")
            local target_dir="$CONFIG_HOME/$dirname"
            mkdir -p "$target_dir"
            cp -r "$item"/* "$target_dir/" 2>/dev/null || true
            echo -e "  ${GREEN}✓${NC} $dirname"
        elif [ -f "$item" ]; then
            local basename=$(basename "$item")
            local ext="${basename##*.}"
            local name="${basename%.*}"

            case "$ext" in
                theme)
                    mkdir -p "$CONFIG_HOME/$name"
                    cp "$item" "$CONFIG_HOME/$name/theme" 2>/dev/null || true
                    echo -e "  ${GREEN}✓${NC} $name.theme"
                    ;;
                conf|toml|ini|css|lua|json)
                    if [ -f "$CONFIG_HOME/$basename" ] || [ -f "$CONFIG_HOME/${name}.$ext" ]; then
                        cp "$item" "$CONFIG_HOME/" 2>/dev/null || true
                        echo -e "  ${GREEN}✓${NC} $basename"
                    fi
                    ;;
            esac
        fi
    done

    local backgrounds_src="$theme_path/backgrounds"
    if [ -d "$backgrounds_src" ]; then
        mkdir -p "$CONFIG_HOME/backgrounds"
        cp -r "$backgrounds_src"/* "$CONFIG_HOME/backgrounds/" 2>/dev/null || true
        echo -e "  ${GREEN}✓${NC} backgrounds"
    fi

    echo -e "${GREEN}Theme '$theme' installed successfully!${NC}"
    echo -e "${YELLOW}Note: Some configs may require manual merging or restart of applications.${NC}"
}

interactive_install() {
    local themes=($(list_themes))
    local total=${#themes[@]}

    if [ $total -eq 0 ]; then
        echo -e "${RED}No themes found in $THEMES_DIR${NC}"
        exit 1
    fi

    echo -e "${YELLOW}╔══════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}║     Omarchy Oasis - Theme Installer      ║${NC}"
    echo -e "${YELLOW}╚══════════════════════════════════════════╝${NC}"
    echo ""
    echo "Available themes:"
    echo ""

    for i in "${!themes[@]}"; do
        local idx=$((i + 1))
        local theme="${themes[$i]}"
        local readme="$THEMES_DIR/$theme/README.md"
        local preview="$THEMES_DIR/$theme/preview.png"

        echo -e "  ${GREEN}$idx)${NC} $theme"
        if [ -f "$readme" ]; then
            local desc=$(head -5 "$readme" | grep -v "^#" | head -2 | tr '\n' ' ')
            if [ -n "$desc" ]; then
                echo "     $desc"
            fi
        fi
        echo ""
    done

    echo -e "${YELLOW}a)${NC} Install all themes"
    echo -e "${YELLOW}q)${NC} Quit"
    echo ""
    read -p "Select theme(s) to install: " choice

    case "$choice" in
        q|Q)
            echo "Cancelled."
            exit 0
            ;;
        a|A)
            for theme in "${themes[@]}"; do
                install_theme "$theme"
            done
            ;;
        *)
            IFS=',' read -ra choices <<< "$choice"
            for ch in "${choices[@]}"; do
                ch=$(echo "$ch" | tr -d ' ')
                if [[ "$ch" =~ ^[0-9]+$ ]] && [ "$ch" -ge 1 ] && [ "$ch" -le $total ]; then
                    install_theme "${themes[$((ch - 1))]}"
                else
                    install_theme "$ch" 2>/dev/null || echo -e "${RED}Invalid selection: $ch${NC}"
                fi
            done
            ;;
    esac
}

show_usage() {
    echo "Usage: $0 [theme_name]"
    echo ""
    echo "Arguments:"
    echo "  theme_name    Install specific theme (e.g., abyss, starlight)"
    echo "  (none)        Run interactive installer"
    echo ""
    echo "Available themes:"
    for theme in $(list_themes); do
        echo "  - $theme"
    done
}

main() {
    if [ $# -eq 0 ]; then
        interactive_install
    else
        case "$1" in
            -h|--help)
                show_usage
                exit 0
                ;;
            *)
                install_theme "$1"
                ;;
        esac
    fi
}

main "$@"
