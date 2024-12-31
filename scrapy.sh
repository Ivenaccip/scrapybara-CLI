#!/bin/bash

# Archivo de log
LOG_FILE="scrapybara_progress.log"

# Colores para mejorar la visibilidad
RESET="\e[0m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
RED="\e[31m"

# Verificar si existe el archivo de log, si no, crear uno
if [[ ! -f $LOG_FILE ]]; then
    echo "Generando archivo de log: $LOG_FILE"
    touch $LOG_FILE
fi

# Función para ejecutar el comando ls
run_ls() {
    echo -e "${BLUE}Ejecutando ls:${RESET}"
    ls
}

# Función para verificar compatibilidad de los scripts
check_compatibility() {
    echo -e "${YELLOW}Verificando compatibilidad de los scripts en el folder actual...${RESET}"
    compatible_count=0
    incompatible_count=0

    # Buscar todos los archivos .py en el directorio actual
    for file in *.py; do
        if [[ -f "$file" ]]; then
            # Verificar si contiene la línea "from scrapybara import Scrapybara"
            if grep -q "from scrapybara import Scrapybara" "$file"; then
                echo -e "${GREEN}[COMPATIBLE] $file${RESET}"
                ((compatible_count++))
            else
                echo -e "${RED}[NO COMPATIBLE] $file${RESET}"
                ((incompatible_count++))
            fi
        fi
    done

    echo -e "${BLUE}Resultados:${RESET}"
    echo "Scripts compatibles: $compatible_count" | tee -a "$LOG_FILE"
    echo "Scripts no compatibles: $incompatible_count" | tee -a "$LOG_FILE"
}

# Menú interactivo
show_menu() {
    clear
    echo -e "${GREEN}Scrapybara CLI - Interfaz Interactiva${RESET}"
    echo "Selecciona una opción:"
    echo "1) Verificar compatibilidad de todos los scripts del folder actual"
    echo "2) Ejecutar comando ls"
    echo "3) Salir"
    echo -n "₍ᐢ•ﻌ•ᐢ₎: "
}

# Lógica principal del menú
while true; do
    show_menu
    read -r option
    case $option in
        1)
            check_compatibility
            ;;
        2)
            run_ls
            ;;
        3)
            echo -e "${BLUE}Saliendo...${RESET}"
            break
            ;;
        *)
            echo -e "${RED}Opción no válida. Intenta de nuevo.${RESET}"
            ;;
    esac
    echo -e "${YELLOW}Presiona Enter para continuar...${RESET}"
    read -r
done
