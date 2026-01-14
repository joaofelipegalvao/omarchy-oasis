#!/bin/bash
# List installed and available Omarchy Oasis themes

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
THEMES_DIR="$REPO_DIR/themes"
INSTALL_DIR="$HOME/.config/omarchy/themes"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Omarchy Oasis Themes - Status        ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}\n"

echo -e "${YELLOW}Available themes in repository:${NC}"
for theme_path in "$THEMES_DIR"/*; do
  if [ -d "$theme_path" ]; then
    theme_name=$(basename "$theme_path")
    installed=""

    # Check if installed
    if [ -d "$INSTALL_DIR/oasis-$theme_name" ]; then
      installed="${GREEN}[INSTALLED]${NC}"
    else
      installed="${YELLOW}[NOT INSTALLED]${NC}"
    fi

    echo -e "  • oasis-$theme_name $installed"
  fi
done

echo -e "\n${YELLOW}Currently installed themes:${NC}"
if [ -d "$INSTALL_DIR" ]; then
  count=0
  for theme_path in "$INSTALL_DIR"/oasis-*; do
    if [ -d "$theme_path" ]; then
      theme_name=$(basename "$theme_path")
      echo -e "  ${GREEN}✓${NC} $theme_name"
      ((count++))
    fi
  done

  if [ $count -eq 0 ]; then
    echo -e "  ${YELLOW}No Oasis themes installed${NC}"
  fi
else
  echo -e "  ${YELLOW}No themes installed${NC}"
fi

echo -e "\n${BLUE}To install themes, run:${NC}"
echo -e "  ${GREEN}./install.sh${NC} (interactive mode)"
echo -e "  ${GREEN}./install.sh <theme-name>${NC} (install specific theme)"
