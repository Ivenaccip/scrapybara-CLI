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

# Función para verificar si `requirements.txt` está instalado
check_requirements_installed() {
    if [[ -f "requirements.txt" ]]; then
        echo -e "${YELLOW}Verificando si requirements.txt está instalado...${RESET}"
        pip freeze > installed_packages.txt
        while read -r package; do
            if ! grep -q "$package" installed_packages.txt; then
                echo -e "${RED}Falta instalar: $package${RESET}"
                echo "Error: Se debe de instalar requirements.txt" | tee -a "$LOG_FILE"
                return 1
            fi
        done < requirements.txt
        echo -e "${GREEN}Todos los paquetes están instalados.${RESET}" | tee -a "$LOG_FILE"
        rm installed_packages.txt
    else
        echo -e "${RED}Error: No se encontró el archivo requirements.txt${RESET}" | tee -a "$LOG_FILE"
        return 1
    fi
}

# Función para verificar las llaves de API
check_api_keys() {
    local missing_keys=0
    if [[ -z "$ANTHROPIC_API_KEY" ]]; then
        echo -e "${RED}Error: Falta la llave ANTHROPIC_API_KEY.${RESET}" | tee -a "$LOG_FILE"
        missing_keys=1
    fi
    if [[ -z "$SCRAPYBARA_API_KEY" ]]; then
        echo -e "${RED}Error: Falta la llave SCRAPYBARA_API_KEY.${RESET}" | tee -a "$LOG_FILE"
        missing_keys=1
    fi
    return $missing_keys
}

# Función para ejecutar un archivo Python compatible
run_python_script() {
    local file=$1
    if [[ -f "$file" ]]; then
        if grep -q "from scrapybara import Scrapybara" "$file"; then
            echo -e "${BLUE}Ejecutando archivo compatible: $file${RESET}"
            python3 "$file" | tee -a "$LOG_FILE"
        else
            echo -e "${RED}Error: El archivo $file no es compatible.${RESET}" | tee -a "$LOG_FILE"
        fi
    else
        echo -e "${RED}Error: El archivo $file no existe.${RESET}" | tee -a "$LOG_FILE"
    fi
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

    # Ejecutar comandos personalizados
    if [[ "$command" == "check_requirements" ]]; then
        check_requirements_installed
    elif [[ "$command" == "check_keys" ]]; then
        check_api_keys
    elif [[ "$command" == *.py ]]; then
        run_python_script "$command"
    else
        # Ejecutar el comando ingresado
        eval "$command"
        # Verificar si el comando tuvo éxito
        if [[ $? -ne 0 ]]; then
            echo -e "${RED}Error al ejecutar el comando: $command${RESET}"
        fi
    fi
done
