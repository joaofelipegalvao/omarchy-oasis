#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEMES_DIR="$SCRIPT_DIR/themes"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

list_themes() {
    ls -d "$THEMES_DIR"/*/ 2>/dev/null | xargs -I {} basename {} | sort
}

show_theme_info() {
    local theme="$1"
    local theme_path="$THEMES_DIR/$theme"
    local readme="$theme_path/README.md"
    local preview="$theme_path/preview.png"

    echo -e "${CYAN}╔══════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║ $theme${NC}"
    local padding=$((40 - ${#theme}))
    for ((i=0; i<padding; i++)); do echo -n " "; done
    echo -e "║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════╝${NC}"
    echo ""

    if [ -f "$readme" ]; then
        echo -e "${YELLOW}Description:${NC}"
        grep -v "^#" "$readme" | head -10 | sed 's/^/  /'
        echo ""
    fi

    echo -e "${YELLOW}Configs included:${NC}"
    for item in "$theme_path"/*; do
        if [ -f "$item" ]; then
            local basename=$(basename "$item")
            local ext="${basename##*.}"
            local name="${basename%.*}"

            case "$basename" in
                preview.png|README.md)
                    continue
                    ;;
                *.theme)
                    echo -e "  ${GREEN}✓${NC} $name (GTK/GTK3)"
                    ;;
                *)
                    case "$ext" in
                        conf|toml|ini|css|lua|json)
                            echo -e "  ${GREEN}✓${NC} $basename"
                            ;;
                    esac
                    ;;
            esac
        elif [ -d "$item" ]; then
            local dirname=$(basename "$item")
            case "$dirname" in
                backgrounds)
                    echo -e "  ${GREEN}✓${NC} wallpapers"
                    ;;
                *)
                    echo -e "  ${GREEN}✓${NC} $dirname"
                    ;;
            esac
        fi
    done

    if [ -f "$preview" ]; then
        echo ""
        echo -e "${YELLOW}Preview:${NC} $preview"
    fi
    echo ""
}

show_usage() {
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  -h, --help       Show this help message"
    echo "  -s, --short      Show only theme names"
    echo "  <theme_name>     Show detailed info for specific theme"
    echo ""
    echo "Examples:"
    echo "  $0                # List all themes with details"
    echo "  $0 --short        # List only theme names"
    echo "  $0 abyss          # Show info for 'abyss' theme"
}

main() {
    local show_short=false

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help)
                show_usage
                exit 0
                ;;
            -s|--short)
                show_short=true
                shift
                ;;
            *)
                break
                ;;
        esac
    done

    local themes=($(list_themes))
    local total=${#themes[@]}

    if [ $total -eq 0 ]; then
        echo -e "${RED}No themes found in $THEMES_DIR${NC}"
        exit 1
    fi

    if [ $# -eq 0 ]; then
        echo -e "${YELLOW}╔══════════════════════════════════════════╗${NC}"
        echo -e "${YELLOW}║     Omarchy Oasis - Available Themes     ║${NC}"
        echo -e "${YELLOW}╚══════════════════════════════════════════╝${NC}"
        echo ""
        echo -e "Found ${GREEN}$total${NC} theme(s):"
        echo ""

        if [ "$show_short" = true ]; then
            for theme in "${themes[@]}"; do
                echo "  - $theme"
            done
        else
            for theme in "${themes[@]}"; do
                show_theme_info "$theme"
            done
        fi

        echo -e "${YELLOW}Install with:${NC} ./install.sh [theme_name]"
    else
        local theme="$1"
        if [ -d "$THEMES_DIR/$theme" ]; then
            show_theme_info "$theme"
        else
            echo -e "${RED}Theme '$theme' not found${NC}"
            echo ""
            echo "Available themes:"
            for t in "${themes[@]}"; do
                echo "  - $t"
            done
            exit 1
        fi
    fi
}

main "$@"
