#!/bin/bash
# Desinstala temas Omarchy Oasis

INSTALL_DIR="$HOME/.config/omarchy/themes"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Função para listar temas instalados
list_installed() {
    echo -e "${BLUE}Temas Oasis instalados:${NC}"
    local i=1
    for theme_path in "$INSTALL_DIR"/oasis-*; do
        if [ -d "$theme_path" ]; then
            theme_name=$(basename "$theme_path")
            echo -e "  ${GREEN}$i)${NC} $theme_name"
            ((i++))
        fi
    done
    
    if [ $i -eq 1 ]; then
        echo -e "  ${YELLOW}Nenhum tema Oasis instalado${NC}"
        return 1
    fi
    return 0
}

# Função para desinstalar tema
uninstall_theme() {
    local theme=$1
    local theme_path="$INSTALL_DIR/$theme"
    
    if [ ! -d "$theme_path" ]; then
        echo -e "${RED}Erro: Tema '$theme' não está instalado${NC}"
        return 1
    fi
    
    echo -e "${YELLOW}Desinstalando: $theme${NC}"
    rm -rf "$theme_path"
    echo -e "${GREEN}✓ Tema removido com sucesso${NC}"
}

# Função para desinstalar todos
uninstall_all() {
    echo -e "${YELLOW}Desinstalando todos os temas Oasis...${NC}\n"
    
    for theme_path in "$INSTALL_DIR"/oasis-*; do
        if [ -d "$theme_path" ]; then
            theme_name=$(basename "$theme_path")
            uninstall_theme "$theme_name"
        fi
    done
    
    echo -e "\n${GREEN}✓ Todos os temas foram removidos!${NC}"
}

# Menu interativo
show_menu() {
    echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║  Desinstalar Omarchy Oasis Themes     ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════╝${NC}\n"
    
    if ! list_installed; then
        exit 0
    fi
    
    echo -e "\n${YELLOW}Opções:${NC}"
    echo -e "  ${GREEN}a)${NC} Desinstalar todos os temas"
    echo -e "  ${GREEN}q)${NC} Sair"
    echo ""
    
    read -p "Escolha um tema (número), 'a' para todos, ou 'q' para sair: " choice
    
    case $choice in
        q|Q)
            echo -e "${BLUE}Saindo...${NC}"
            exit 0
            ;;
        a|A)
            read -p "Tem certeza que deseja remover TODOS os temas? (s/N): " confirm
            if [[ $confirm == [sS] ]]; then
                uninstall_all
            else
                echo -e "${YELLOW}Operação cancelada${NC}"
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
                read -p "Desinstalar '${themes[$idx]}'? (s/N): " confirm
                if [[ $confirm == [sS] ]]; then
                    uninstall_theme "${themes[$idx]}"
                else
                    echo -e "${YELLOW}Operação cancelada${NC}"
                fi
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
    if [ $# -eq 1 ]; then
        theme=$1
        # Adicionar prefixo "oasis-" se não tiver
        [[ $theme != oasis-* ]] && theme="oasis-$theme"
        
        uninstall_theme "$theme"
    else
        show_menu
    fi
}

main "$@"
