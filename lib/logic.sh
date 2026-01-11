#!/bin/bash
set -euo pipefail

# Используем sudo, если скрипт запущен не от root
SUDO=""
[[ "$EUID" -ne 0 ]] && SUDO="sudo"

# =========================================================
# CLI
# =========================================================
CLI_IDS=(koda qwen gemini)

CLI_NAME[koda]="Koda CLI"
CLI_NAME[qwen]="Qwen CLI"
CLI_NAME[gemini]="Gemini CLI"

CLI_PKG[koda]="@kodadev/koda-cli"
CLI_PKG[qwen]="@qwen-code/qwen-code"
CLI_PKG[gemini]="@google/gemini-cli"

CLI_CMD[koda]="koda"
CLI_CMD[qwen]="qwen"
CLI_CMD[gemini]="gemini"

# =========================================================
# ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ
# =========================================================

# Проверка: установлена ли CLI
cli_is_installed() {
    command -v "$1" >/dev/null 2>&1
}

# =========================================================
# NODE.JS
# =========================================================

# Проверка версии Node.js и установка версии 20
sys_check_node() {
    msg_start "Проверка Node.js"

    if command -v node >/dev/null 2>&1; then
        VER=$(node -v | sed 's/v//' | cut -d. -f1)
        if [[ "$VER" -ge 20 ]]; then
            msg_ok
            return
        fi
    fi

    msg_ok
    msg_start "Установка Node.js 20"

    curl -fsSL https://deb.nodesource.com/setup_20.x | $SUDO bash -
    $SUDO apt-get install -y nodejs

    msg_ok
}

# =========================================================
# УСТАНОВКА CLI
# =========================================================

# Установка выбранной CLI в изолированную директорию /opt
sys_install_tool() {
    local id="$1"
    local NAME="${CLI_NAME[$id]}"
    local PKG="${CLI_PKG[$id]}"
    local CMD="${CLI_CMD[$id]}"
    local DIR="/opt/$CMD"
    local BIN="$DIR/node_modules/.bin/$CMD"

    # Если CLI уже установлена — пропускаем
    if cli_is_installed "$CMD"; then
        msg_ok "$NAME уже установлен — пропуск"
        return
    fi

    msg_start "Установка $NAME"

    # Создание директории установки
    $SUDO mkdir -p "$DIR"
    $SUDO chown -R "$USER":"$USER" "$DIR"

    # Установка npm-пакета
    npm install "$PKG" --prefix "$DIR" --silent

    # Проверка наличия бинарника
    [[ -x "$BIN" ]] || msg_err "Бинарник $CMD не найден"

    # Симлинк в /usr/local/bin
    $SUDO ln -sf "$BIN" "/usr/local/bin/$CMD"

    msg_ok
}
