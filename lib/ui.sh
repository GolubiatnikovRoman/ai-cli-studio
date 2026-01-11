#!/bin/bash
set -euo pipefail

# Цвета и стили
R="\033[0m"; B="\033[1m"
G="\033[32m"; E="\033[31m"; BL="\033[34m"; GR="\033[90m"; M="\033[35m"

# Баннер установщика
ui_banner() {
    clear
    echo -e "${M}${B}"
    echo "  ____ _     ___   ____  _____ _   _ ____  ___ ___  "
    echo " / ___| |   |_ _| / ___||_   _| | | |  _ \\|_ _/ _ \\ "
    echo "| |   | |    | |  \\___ \\  | | | | | | | | || | | | |"
    echo "| |___| |___ | |   ___) | | | | |_| | |_| || | |_| |"
    echo " \\____|_____|___| |____/  |_|  \\___/|____/|___\\___/ "
    echo -e "${R}"
    echo -e " ${GR}Целевая директория: /opt${R}"
    echo -e "${GR}------------------------------------------------${R}"
}

# Сообщение о начале операции
msg_start() {
    echo -ne " ${BL}▶${R} $1... "
}

# Успешное завершение операции
msg_ok() {
    echo -e "${G}OK${R}"
}

# Ошибка с завершением скрипта
msg_err() {
    echo -e "${E}FAIL${R}"
    echo -e " ${E}✖${R} $1"
    exit 1
}

# Окно выбора CLI
ui_select_cli() {
    local items=()

    for id in "${CLI_IDS[@]}"; do
        local name="${CLI_NAME[$id]}"
        local cmd="${CLI_CMD[$id]}"

        if cli_is_installed "$cmd"; then
            items+=("$id" "[✔] $name (установлено)" "OFF")
        else
            items+=("$id" "[ ] $name" "ON")
        fi
    done

    whiptail \
      --title "AI CLI Studio" \
      --checklist "Выберите CLI для установки:" \
      20 70 10 \
      "${items[@]}" \
      3>&1 1>&2 2>&3
}

# Итоговая таблица
ui_summary() {
    echo -e "\n${GR}------------------------------------------------${R}"
    echo -e " ${G}${B}УСТАНОВКА ЗАВЕРШЕНА${R}"
    echo -e "${GR}------------------------------------------------${R}"

    for id in "${CLI_IDS[@]}"; do
        local name="${CLI_NAME[$id]}"
        local cmd="${CLI_CMD[$id]}"

        if cli_is_installed "$cmd"; then
            printf " %-12s ${G}%-10s${R} /opt/%s\n" "$name" "Активен" "$cmd"
        else
            printf " %-12s ${GR}%-10s${R} -\n" "$name" "Пропущен"
        fi
    done

    echo ""
}
