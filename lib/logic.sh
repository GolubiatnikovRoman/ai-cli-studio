#!/bin/bash

SUDO=""; [ "$EUID" -ne 0 ] && SUDO="sudo"

sys_check_node() {
    msg_start "Проверка окружения (Node.js)"
    if command -v node >/dev/null 2>&1; then
        VER=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
        if [ "$VER" -ge 20 ]; then
            msg_ok "Node.js v$VER ок"
            return
        fi
    fi
    # Тихая установка
    curl -fsSL https://deb.nodesource.com/setup_20.x | $SUDO bash - >/dev/null 2>&1
    $SUDO apt-get install -y nodejs >/dev/null 2>&1
    msg_ok "Node.js обновлен до LTS"
}

sys_install_tool() {
    NAME=$1
    PKG=$2
    CMD=$3
    DIR="/opt/$CMD"

    msg_start "Установка $NAME"

    # 1. Очистка
    $SUDO rm -rf "$DIR" 2>/dev/null
    if ! $SUDO mkdir -p "$DIR"; then
        msg_err "Нет прав на создание $DIR"
    fi

    # 2. Установка
    if ! $SUDO npm install -g --prefix "$DIR" "$PKG" --loglevel=error >/dev/null 2>&1; then
        msg_err "Ошибка npm install"
    fi

    # 3. Поиск бинарника (FIX: рекурсивный поиск)
    TARGET=$(find "$DIR" -type f -name "$CMD" 2>/dev/null | head -n 1)
    
    # Fallback: любой файл в bin, если по имени не нашли
    if [ -z "$TARGET" ]; then
        TARGET=$(find "$DIR/bin" -type f 2>/dev/null | head -n 1)
    fi

    if [ -f "$TARGET" ] && [ -n "$TARGET" ]; then
        $SUDO chmod +x "$TARGET"
        $SUDO ln -sf "$TARGET" "/usr/local/bin/$CMD"
        msg_ok "$NAME готов"
    else
        msg_err "Бинарник не найден в $DIR"
    fi
}
