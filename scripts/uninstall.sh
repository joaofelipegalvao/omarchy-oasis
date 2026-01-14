#!/bin/bash
# Uninstall Omarchy Oasis Themes

INSTALL_DIR="$HOME/.config/omarchy/themes"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Function to list installed themes
list_installed() {
    echo -e "${BLUE}Installed Oasis themes:${NC}"
    local i=1
    for theme_path in "$INSTALL_DIR"/oasis-*; do
        if [ -d "$theme_path" ]; then
            theme_name=$(basename "$theme_path")
            echo -e "  ${GREEN}$i)${NC} $theme_name"
            ((i++))
        fi
    done

    if [ $i -eq 1 ]; then
        echo -e "  ${YELLOW}No Oasis themes installed${NC}"
        return 1
    fi
    return 0
}

# Function to uninstall theme
uninstall_theme() {
    local theme=$1
    local theme_path="$INSTALL_DIR/$theme"

    if [ ! -d "$theme_path" ]; then
        echo -e "${RED}Error: Theme '$theme' is not installed${NC}"
        return 1
    fi

    echo -e "${YELLOW}Uninstalling: $theme${NC}"
    rm -rf "$theme_path"
    echo -e "${GREEN}✓ Theme removed successfully${NC}"
}

# Function to uninstall all themes
uninstall_all() {
    echo -e "${YELLOW}Uninstalling all Oasis themes...${NC}\n"

    for theme_path in "$INSTALL_DIR"/oasis-*; do
        if [ -d "$theme_path" ]; then
            theme_name=$(basename "$theme_path")
            uninstall_theme "$theme_name"
        fi
    done

    echo -e "\n${GREEN}✓ All themes have been removed!${NC}"
}

# Interactive menu
show_menu() {
    echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║   Uninstall Omarchy Oasis Themes      ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════╝${NC}\n"

    if ! list_installed; then
        exit 0
    fi

    echo -e "\n${YELLOW}Options:${NC}"
    echo -e "  ${GREEN}a)${NC} Uninstall all themes"
    echo -e "  ${GREEN}q)${NC} Quit"
    echo ""

    read -p "Choose a theme (number), 'a' for all, or 'q' to quit: " choice

    case $choice in
        q | Q)
            echo -e "${BLUE}Exiting...${NC}"
            exit 0
            ;;
        a | A)
            read -p "Are you sure you want to remove ALL themes? (y/N): " confirm
            if [[ $confirm == [yY] ]]; then
                uninstall_all
            else
                echo -e "${YELLOW}Operation cancelled${NC}"
            fi
            ;;
        [0-9]*)
            local themes=()
            for theme_path in "$INSTALL_DIR"/oasis-*; do
                if [ -d "$theme_path" ]; then
                    themes+=("$(basename "$theme_path")")
                fi
            done

            local idx=$((choice - 1))
            if [ $idx -ge 0 ] && [ $idx -lt ${#themes[@]} ]; then
                read -p "Uninstall '${themes[$idx]}'? (y/N): " confirm
                if [[ $confirm == [yY] ]]; then
                    uninstall_theme "${themes[$idx]}"
                else
                    echo -e "${YELLOW}Operation cancelled${NC}"
                fi
            else
                echo -e "${RED}Invalid option!${NC}"
                exit 1
            fi
            ;;
        *)
            echo -e "${RED}Invalid option!${NC}"
            exit 1
            ;;
    esac
}

# Main
main() {
    if [ $# -eq 1 ]; then
        theme=$1
        # Add "oasis-" prefix if not present
        [[ $theme != oasis-* ]] && theme="oasis-$theme"

        uninstall_theme "$theme"
    else
        show_menu
    fi
}

main "$@"
