#!/bin/bash

R="\033[0m"; B="\033[1m"
G="\033[32m"; E="\033[31m"; BL="\033[34m"; GR="\033[90m"; M="\033[35m"

ui_banner() {
    clear
    echo -e "${M}${B}"
    echo "  ____ _     ___   ____  _____ _   _ ____  ___ ___  "
    echo " / ___| |   |_ _| / ___||_   _| | | |  _ \|_ _/ _ \ "
    echo "| |   | |    | |  \___ \  | | | | | | | | || | | | |"
    echo "| |___| |___ | |   ___) | | | | |_| | |_| || | |_| |"
    echo " \____|_____|___| |____/  |_|  \___/|____/|___\___/ "
    echo -e "${R}"
    echo -e " ${GR}Target: /opt directories${R}"
    echo -e "${GR}------------------------------------------------${R}"
}

msg_start() {
    echo -ne " ${BL}::${R} $1... "
}

msg_ok() {
    echo -e "\r ${G}✔${R} $1                               "
}

msg_err() {
    echo -e "\r ${E}✖${R} $1                               "
    exit 1
}

ui_summary() {
    echo -e "\n${GR}------------------------------------------------${R}"
    echo -e " ${G}${B}УСТАНОВКА ЗАВЕРШЕНА${R}"
    echo -e "${GR}------------------------------------------------${R}"
    printf " %-12s %-10s %s\n" "CLI" "STATUS" "PATH"
    printf " %-12s ${G}%-10s${R} %s\n" "Koda"   "Active" "/opt/koda"
    printf " %-12s ${G}%-10s${R} %s\n" "Qwen"   "Active" "/opt/qwen"
    printf " %-12s ${G}%-10s${R} %s\n" "Gemini" "Active" "/opt/gemini"
    echo ""
}
