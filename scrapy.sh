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

# Bucle principal para leer comandos
while true; do
    # Mostrar el prompt personalizado
    echo -n "₍ᐢ•ﻌ•ᐢ₎: "
    # Leer el comando del usuario
    read -r command

    # Verificar si el usuario ingresó "exit" para salir
    if [[ "$command" == "exit" ]]; then
        echo -e "${BLUE}Saliendo...${RESET}"
        break
    fi

    # Comprobar si el comando es "check"
    if [[ "$command" == "check" ]]; then
        check_compatibility
    else
        # Ejecutar el comando ingresado
        eval "$command"
        # Verificar si el comando tuvo éxito
        if [[ $? -ne 0 ]]; then
            echo -e "${RED}Error al ejecutar el comando: $command${RESET}"
        fi
    fi
done
