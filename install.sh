#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ ! -f "$ROOT_DIR/lib/ui.sh" || ! -f "$ROOT_DIR/lib/logic.sh" ]]; then
    echo "Ошибка: библиотеки не найдены"
    exit 1
fi

source "$ROOT_DIR/lib/ui.sh"
source "$ROOT_DIR/lib/logic.sh"

main() {
    ui_banner

    sys_detect_os
    sys_check_node
    echo ""

    SELECTED=$(ui_select_cli) || exit 0

    for id in $SELECTED; do
        id="${id//\"/}"
        sys_install_tool "$id"
    done

    ui_summary
}

main
