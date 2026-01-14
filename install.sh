#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
THEMES_DIR="$SCRIPT_DIR/themes"
OMARCHY_THEMES="$HOME/.local/share/omarchy/themes"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

list_themes() {
    ls -d "$THEMES_DIR"/*/ 2>/dev/null | xargs -I {} basename {} | sort
}

generate_colors_toml() {
    local theme="$1"
    local theme_path="$THEMES_DIR/$theme"
    local colors_file="$OMARCHY_THEMES/oasis-$theme/colors.toml"

    case "$theme" in
        abyss)
            cat > "$colors_file" << 'EOF'
accent = "#ff6b6b"
cursor = "#cba6f7"
foreground = "#cdd6f4"
background = "#1e1e2e"
selection_foreground = "#1e1e2e"
selection_background = "#ff6b6b"

color0 = "#45475a"
color1 = "#ff6b6b"
color2 = "#a6e3a1"
color3 = "#f9e2af"
color4 = "#89b4fa"
color5 = "#f5c2e7"
color6 = "#94e2d5"
color7 = "#bac2de"
color8 = "#585b70"
color9 = "#ff6b6b"
color10 = "#a6e3a1"
color11 = "#f9e2af"
color12 = "#89b4fa"
color13 = "#f5c2e7"
color14 = "#94e2d5"
color15 = "#a6adc8"
EOF
            ;;
        starlight)
            cat > "$colors_file" << 'EOF'
accent = "#519bff"
cursor = "#1e1e2e"
foreground = "#1e1e2e"
background = "#f5f5f5"
selection_foreground = "#f5f5f5"
selection_background = "#519bff"

color0 = "#585b70"
color1 = "#ff6b6b"
color2 = "#a6e3a1"
color3 = "#f9e2af"
color4 = "#519bff"
color5 = "#f5c2e7"
color6 = "#94e2d5"
color7 = "#45475a"
color8 = "#6c7086"
color9 = "#ff6b6b"
color10 = "#a6e3a1"
color11 = "#f9e2af"
color12 = "#519bff"
color13 = "#f5c2e7"
color14 = "#94e2d5"
color15 = "#cdd6f4"
EOF
            ;;
    esac
}

install_theme() {
    local theme="$1"
    local theme_path="$THEMES_DIR/$theme"
    local target_dir="$OMARCHY_THEMES/oasis-$theme"

    if [ ! -d "$theme_path" ]; then
        echo -e "${RED}Error: Theme '$theme' not found${NC}"
        return 1
    fi

    echo -e "${GREEN}Installing theme: oasis-$theme${NC}"

    mkdir -p "$target_dir"
    mkdir -p "$target_dir/backgrounds"

    generate_colors_toml "$theme"

    for item in "$theme_path"/*; do
        local basename=$(basename "$item")

        case "$basename" in
            colors.toml|README.md|preview.png|hyprland.conf|hyprlock.conf)
                continue
                ;;
            backgrounds)
                cp -r "$item"/* "$target_dir/backgrounds/" 2>/dev/null || true
                echo -e "  ${GREEN}✓${NC} backgrounds"
                ;;
            *)
                if [ -f "$item" ]; then
                    cp "$item" "$target_dir/"
                    echo -e "  ${GREEN}✓${NC} $basename"
                fi
                ;;
        esac
    done

    if [ -f "$theme_path/preview.png" ]; then
        cp "$theme_path/preview.png" "$target_dir/"
    fi

    echo ""
    echo -e "${GREEN}Theme 'oasis-$theme' installed to $OMARCHY_THEMES/oasis-$theme${NC}"
    echo ""
    echo -e "${YELLOW}To activate the theme, run:${NC}"
    echo -e "  ${GREEN}omarchy-theme-set oasis-$theme${NC}"
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
    echo ""
    echo "Themes are installed to ~/.local/share/omarchy/themes/"
    echo "Use 'omarchy-theme-set oasis-<theme>' to activate."
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
