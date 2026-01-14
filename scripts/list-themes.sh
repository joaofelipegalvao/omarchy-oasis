#!/bin/bash
# Lista temas Omarchy Oasis instalados e disponíveis

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
THEMES_DIR="$REPO_DIR/themes"
INSTALL_DIR="$HOME/.config/omarchy/themes"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Omarchy Oasis Themes - Status       ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}\n"

echo -e "${YELLOW}Temas disponíveis no repositório:${NC}"
for theme_path in "$THEMES_DIR"/*; do
    if [ -d "$theme_path" ]; then
        theme_name=$(basename "$theme_path")
        installed=""
        
        # Verificar se está instalado
        if [ -d "$INSTALL_DIR/oasis-$theme_name" ]; then
            installed="${GREEN}[INSTALADO]${NC}"
        else
            installed="${YELLOW}[NÃO INSTALADO]${NC}"
        fi
        
        echo -e "  • oasis-$theme_name $installed"
    fi
done

echo -e "\n${YELLOW}Temas atualmente instalados:${NC}"
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
        echo -e "  ${YELLOW}Nenhum tema Oasis instalado${NC}"
    fi
else
    echo -e "  ${YELLOW}Nenhum tema instalado${NC}"
fi

echo -e "\n${BLUE}Para instalar temas, execute:${NC}"
echo -e "  ${GREEN}./install.sh${NC} (modo interativo)"
echo -e "  ${GREEN}./install.sh <nome-do-tema>${NC} (instalar tema específico)"
