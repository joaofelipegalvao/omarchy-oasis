#!/bin/bash
# Instalador de temas Omarchy Oasis
# Uso: ./install.sh [nome-do-tema]

set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEMES_DIR="$REPO_DIR/themes"
INSTALL_DIR="$HOME/.config/omarchy/themes"

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Função para listar temas disponíveis
list_themes() {
    echo -e "${BLUE}Temas disponíveis:${NC}"
    local i=1
    for theme_path in "$THEMES_DIR"/*; do
        if [ -d "$theme_path" ]; then
            theme_name=$(basename "$theme_path")
            echo -e "  ${GREEN}$i)${NC} oasis-$theme_name"
            ((i++))
        fi
    done
}

# Função para validar se tema existe
theme_exists() {
    local theme=$1
    [ -d "$THEMES_DIR/$theme" ]
}

# Função para instalar tema
install_theme() {
    local theme=$1
    local theme_src="$THEMES_DIR/$theme"
    local theme_dest="$INSTALL_DIR/oasis-$theme"
    
    echo -e "${BLUE}Instalando tema: oasis-$theme${NC}"
    
    # Criar diretório de destino
    mkdir -p "$INSTALL_DIR"
    
    # Remover instalação anterior se existir
    if [ -d "$theme_dest" ]; then
        echo -e "${YELLOW}Tema já instalado. Removendo versão anterior...${NC}"
        rm -rf "$theme_dest"
    fi
    
    # Copiar tema
    echo -e "${BLUE}Copiando arquivos...${NC}"
    cp -r "$theme_src" "$theme_dest"
    
    echo -e "${GREEN}✓ Tema instalado em: $theme_dest${NC}"
    echo -e "${YELLOW}Para aplicar o tema, execute:${NC}"
    echo -e "  ${GREEN}omarchy-theme-set oasis-$theme${NC}"
}

# Função para instalar todos os temas
install_all() {
    echo -e "${BLUE}Instalando todos os temas...${NC}\n"
    for theme_path in "$THEMES_DIR"/*; do
        if [ -d "$theme_path" ]; then
            theme_name=$(basename "$theme_path")
            install_theme "$theme_name"
            echo ""
        fi
    done
    echo -e "${GREEN}✓ Todos os temas foram instalados!${NC}"
}

# Menu interativo
show_menu() {
    echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║   Instalador Omarchy Oasis Themes     ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════╝${NC}\n"
    
    list_themes
    
    echo -e "\n${YELLOW}Opções:${NC}"
    echo -e "  ${GREEN}a)${NC} Instalar todos os temas"
    echo -e "  ${GREEN}q)${NC} Sair"
    echo ""
    
    read -p "Escolha um tema (número), 'a' para todos, ou 'q' para sair: " choice
    
    case $choice in
        q|Q)
            echo -e "${BLUE}Saindo...${NC}"
            exit 0
            ;;
        a|A)
            install_all
            ;;
        [0-9]*)
            # Converter número em nome do tema
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
                echo -e "${RED}Opção inválida!${NC}"
                exit 1
            fi
            ;;
        *)
            echo -e "${RED}Opção inválida!${NC}"
            exit 1
            ;;
    esac
}

# Main
main() {
    # Verificar se diretório de temas existe
    if [ ! -d "$THEMES_DIR" ]; then
        echo -e "${RED}Erro: Diretório de temas não encontrado!${NC}"
        echo -e "Esperado: $THEMES_DIR"
        exit 1
    fi
    
    # Se recebeu argumento, instalar tema específico
    if [ $# -eq 1 ]; then
        theme=$1
        # Remover prefixo "oasis-" se fornecido
        theme=${theme#oasis-}
        
        if theme_exists "$theme"; then
            install_theme "$theme"
        else
            echo -e "${RED}Erro: Tema '$theme' não encontrado!${NC}\n"
            list_themes
            exit 1
        fi
    else
        # Modo interativo
        show_menu
    fi
}

main "$@"
