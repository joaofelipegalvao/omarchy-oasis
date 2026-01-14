#!/bin/bash
# Omarchy Oasis Theme Installer
# Usage: ./install.sh [theme-name]

set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEMES_DIR="$REPO_DIR/themes"
INSTALL_DIR="$HOME/.config/omarchy/themes"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to list available themes
list_themes() {
  echo -e "${BLUE}Available themes:${NC}"
  local i=1
  for theme_path in "$THEMES_DIR"/*; do
    if [ -d "$theme_path" ]; then
      theme_name=$(basename "$theme_path")
      echo -e "  ${GREEN}$i)${NC} oasis-$theme_name"
      ((i++))
    fi
  done
}

# Function to check if theme exists
theme_exists() {
  local theme=$1
  [ -d "$THEMES_DIR/$theme" ]
}

# Function to install theme
install_theme() {
  local theme=$1
  local theme_src="$THEMES_DIR/$theme"
  local theme_dest="$INSTALL_DIR/oasis-$theme"

  echo -e "${BLUE}Installing theme: oasis-$theme${NC}"

  # Create destination directory
  mkdir -p "$INSTALL_DIR"

  # Remove previous installation if exists
  if [ -d "$theme_dest" ]; then
    echo -e "${YELLOW}Theme already installed. Removing previous version...${NC}"
    rm -rf "$theme_dest"
  fi

  # Copy theme
  echo -e "${BLUE}Copying files...${NC}"
  cp -r "$theme_src" "$theme_dest"

  echo -e "${GREEN}✓ Theme installed at: $theme_dest${NC}"
  echo -e "${YELLOW}To apply the theme, run:${NC}"
  echo -e "  ${GREEN}omarchy-theme-set oasis-$theme${NC}"
}

# Function to install all themes
install_all() {
  echo -e "${BLUE}Installing all themes...${NC}\n"
  for theme_path in "$THEMES_DIR"/*; do
    if [ -d "$theme_path" ]; then
      theme_name=$(basename "$theme_path")
      install_theme "$theme_name"
      echo ""
    fi
  done
  echo -e "${GREEN}✓ All themes have been installed!${NC}"
}

# Interactive menu
show_menu() {
  echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
  echo -e "${BLUE}║   Omarchy Oasis Theme Installer        ║${NC}"
  echo -e "${BLUE}╚════════════════════════════════════════╝${NC}\n"

  list_themes

  echo -e "\n${YELLOW}Options:${NC}"
  echo -e "  ${GREEN}a)${NC} Install all themes"
  echo -e "  ${GREEN}q)${NC} Quit"
  echo ""

  read -p "Choose a theme (number), 'a' for all, or 'q' to quit: " choice

  case $choice in
  q | Q)
    echo -e "${BLUE}Exiting...${NC}"
    exit 0
    ;;
  a | A)
    install_all
    ;;
  [0-9]*)
    # Convert number to theme name
    local themes=()
    for theme_path in "$THEMES_DIR"/*; do
      if [ -d "$theme_path" ]; then
        themes+=("$(basename "$theme_path")")
      fi
    done

    local idx=$((choice - 1))
    if [ $idx -ge 0 ] && [ $idx -lt ${#themes[@]} ]; then
      install_theme "${themes[$idx]}"
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
  # Check if themes directory exists
  if [ ! -d "$THEMES_DIR" ]; then
    echo -e "${RED}Error: Themes directory not found!${NC}"
    echo -e "Expected: $THEMES_DIR"
    exit 1
  fi

  # If argument provided, install specific theme
  if [ $# -eq 1 ]; then
    theme=$1
    # Remove "oasis-" prefix if provided
    theme=${theme#oasis-}

    if theme_exists "$theme"; then
      install_theme "$theme"
    else
      echo -e "${RED}Error: Theme '$theme' not found!${NC}\n"
      list_themes
      exit 1
    fi
  else
    # Interactive mode
    show_menu
  fi
}

main "$@"
