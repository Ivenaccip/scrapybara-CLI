#!/bin/bash

# Archivo de log
LOG_FILE="scrapybara_progress.log"

# Colores para mejorar la visibilidad
RESET="\e[0m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
RED="\e[31m"

# Verificar si existe el archivo de log, si no, crearlo
if [[ ! -f $LOG_FILE ]]; then
    echo "Generando archivo de log: $LOG_FILE"
    touch $LOG_FILE
fi

# Función para listar archivos y marcar compatibilidad
list_and_check_files() {
    echo -e "${BLUE}Listando archivos y verificando compatibilidad:${RESET}"

    # Buscar todos los archivos en el directorio actual
    for file in *; do
        # Solo procesar archivos .py
        if [[ -f "$file" && "$file" == *.py ]]; then
            # Verificar compatibilidad
            if grep -q "from scrapybara import Scrapybara" "$file"; then
                echo -e "${GREEN}[COMPATIBLE] $file${RESET}"
            else
                echo -e "${RED}[NO COMPATIBLE] $file${RESET}"
            fi
        elif [[ -f "$file" ]]; then
            # Otros archivos normales
            echo -e "${YELLOW}[OTRO ARCHIVO] $file${RESET}"
        fi
    done
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

    # Ejecutar `ls` con verificación de compatibilidad
    if [[ "$command" == "ls" ]]; then
        list_and_check_files
    else
        # Ejecutar el comando ingresado
        eval "$command"
        # Verificar si el comando tuvo éxito
        if [[ $? -ne 0 ]]; then
            echo -e "${RED}Error al ejecutar el comando: $command${RESET}"
        fi
    fi
done
