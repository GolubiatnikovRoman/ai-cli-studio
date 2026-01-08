#!/bin/bash

# Получаем абсолютный путь к скрипту
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Подключаем модули
source "$ROOT_DIR/lib/ui.sh"
source "$ROOT_DIR/lib/logic.sh"

# Основной пайплайн
main() {
    ui_banner
    
    # 1. Проверка окружения
    sys_check_node
    echo ""

    # 2. Установка инструментов
    # Формат: "Display Name" "NPM Package" "Binary/Folder Name"
    sys_install_tool "Koda CLI"   "@kodadev/koda-cli"    "koda"
    sys_install_tool "Qwen CLI"   "@qwen-code/qwen-code" "qwen"
    sys_install_tool "Gemini CLI" "@google/gemini-cli"   "gemini"

    # 3. Финал
    ui_summary
}

main
