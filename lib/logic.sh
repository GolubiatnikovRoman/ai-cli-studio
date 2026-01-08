#!/bin/bash
set -euo pipefail

SUDO=""
[[ "$EUID" -ne 0 ]] && SUDO="sudo"

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

sys_install_tool() {
    local NAME="$1"
    local PKG="$2"
    local CMD="$3"
    local DIR="/opt/$CMD"
    local BIN="$DIR/node_modules/.bin/$CMD"

    msg_start "Установка $NAME"

    $SUDO rm -rf "$DIR"
    $SUDO mkdir -p "$DIR"
    $SUDO chown -R "$USER":"$USER" "$DIR"

    npm install "$PKG" --prefix "$DIR" --silent

    if [[ ! -x "$BIN" ]]; then
        msg_err "Бинарник $CMD не найден в node_modules/.bin"
    fi

    $SUDO ln -sf "$BIN" "/usr/local/bin/$CMD"

    msg_ok
}

