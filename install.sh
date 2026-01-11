#!/bin/bash
set -euo pipefail

# Корневая директория проекта
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Проверка наличия библиотек
if [[ ! -f "$ROOT_DIR/lib/ui.sh" || ! -f "$ROOT_DIR/lib/logic.sh" ]]; then
    echo "Ошибка: библиотеки не найдены в $ROOT_DIR/lib"
    exit 1
fi

# Подключение UI и логики
source "$ROOT_DIR/lib/ui.sh"
source "$ROOT_DIR/lib/logic.sh"

main() {
    # Отрисовка баннера
    ui_banner

    # Проверка и установка Node.js (если требуется)
    sys_check_node
    echo ""

    # Окно выбора CLI
    SELECTED=$(ui_select_cli) || exit 0

    # Установка выбранных CLI
    for id in $SELECTED; do
        id="${id//\"/}"
        sys_install_tool "$id"
    done

    # Итоговая сводка
    ui_summary
}

main
