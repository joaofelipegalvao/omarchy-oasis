#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
THEMES_DIR="$SCRIPT_DIR/themes"
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
OMARCHY_THEMES="$CONFIG_HOME/omarchy/themes"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

list_themes() {
    ls -d "$THEMES_DIR"/*/ 2>/dev/null | xargs -I {} basename {} | sort
}

install_config() {
    local src="$1"
    local basename=$(basename "$src")

    case "$basename" in
        hyprland.conf)
            cp "$src" "$CONFIG_HOME/hyprland.conf" 2>/dev/null || true
            ;;
        waybar.css)
            cp "$src" "$CONFIG_HOME/waybar.css" 2>/dev/null || true
            ;;
        alacritty.toml)
            cp "$src" "$CONFIG_HOME/alacritty.toml" 2>/dev/null || true
            ;;
        ghostty.conf)
            cp "$src" "$CONFIG_HOME/ghostty.conf" 2>/dev/null || true
            ;;
        kitty.conf)
            cp "$src" "$CONFIG_HOME/kitty.conf" 2>/dev/null || true
            ;;
        mako.ini)
            cp "$src" "$CONFIG_HOME/mako.ini" 2>/dev/null || true
            ;;
        neovim.lua)
            mkdir -p "$CONFIG_HOME/nvim/lua/user"
            cp "$src" "$CONFIG_HOME/nvim/lua/user/colorscheme.lua" 2>/dev/null || true
            ;;
        hyprlock.conf)
            cp "$src" "$CONFIG_HOME/hyprlock.conf" 2>/dev/null || true
            ;;
        btop.theme)
            mkdir -p "$CONFIG_HOME/btop/themes"
            cp "$src" "$CONFIG_HOME/btop/themes/" 2>/dev/null || true
            ;;
        chromium.theme)
            mkdir -p "$CONFIG_HOME/chromium"
            cp "$src" "$CONFIG_HOME/chromium/" 2>/dev/null || true
            ;;
        icons.theme)
            mkdir -p "$CONFIG_HOME/icons"
            cp "$src" "$CONFIG_HOME/icons/" 2>/dev/null || true
            ;;
        swayosd.css)
            cp "$src" "$CONFIG_HOME/swayosd.css" 2>/dev/null || true
            ;;
        walker.css)
            cp "$src" "$CONFIG_HOME/walker.css" 2>/dev/null || true
            ;;
        vscode.json)
            mkdir -p "$CONFIG_HOME/Code - OSS/User/snippets"
            cp "$src" "$CONFIG_HOME/Code - OSS/User/snippets/" 2>/dev/null || true
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

    for item in "$theme_path"/*; do
        local basename=$(basename "$item")

        case "$basename" in
            backgrounds)
                cp -r "$item"/* "$target_dir/backgrounds/" 2>/dev/null || true
                echo -e "  ${GREEN}✓${NC} backgrounds"
                ;;
            *.png)
                if [ "$basename" != "preview.png" ]; then
                    cp "$item" "$target_dir/backgrounds/"
                    echo -e "  ${GREEN}✓${NC} background"
                else
                    cp "$item" "$target_dir/"
                    echo -e "  ${GREEN}✓${NC} $basename"
                fi
                ;;
            *)
                if [ -f "$item" ]; then
                    cp "$item" "$target_dir/"
                    echo -e "  ${GREEN}✓${NC} $basename"
                    install_config "$item"
                fi
                ;;
        esac
    done

    echo ""
    echo -e "${GREEN}Theme 'oasis-$theme' installed!${NC}"
    echo -e "${YELLOW}Files copied to:${NC}"
    echo "  - $target_dir"
    echo ""
    echo -e "${YELLOW}Configs also applied to ~/.config/${NC}"
    echo ""
    echo -e "${YELLOW}To set as active theme:${NC}"
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
    echo "Themes are installed to ~/.config/omarchy/themes/"
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
