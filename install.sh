#!/bin/bash

# Определяем путь скрипта
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Проверка наличия библиотек
if [ ! -f "$ROOT_DIR/lib/ui.sh" ] || [ ! -f "$ROOT_DIR/lib/logic.sh" ]; then
    echo "Error: Libraries not found in $ROOT_DIR/lib"
    exit 1
fi

# Импорт
source "$ROOT_DIR/lib/ui.sh"
source "$ROOT_DIR/lib/logic.sh"

main() {
    ui_banner
    
    sys_check_node
    echo ""

    sys_install_tool "Koda CLI"   "@kodadev/koda-cli"    "koda"
    sys_install_tool "Qwen CLI"   "@qwen-code/qwen-code" "qwen"
    sys_install_tool "Gemini CLI" "@google/gemini-cli"   "gemini"

    ui_summary
}

main
