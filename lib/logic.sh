#!/bin/bash

# Если не root, используем sudo
SUDO=""; [ "$EUID" -ne 0 ] && SUDO="sudo"

# Проверка Node.js (v20+)
sys_check_node() {
    msg_start "Проверка окружения (Node.js)"
    
    if command -v node >/dev/null 2>&1; then
        VER=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
        if [ "$VER" -ge 20 ]; then
            msg_ok "Node.js v$VER ок"
            return
        fi
    fi

    # Установка/Обновление
    curl -fsSL https://deb.nodesource.com/setup_20.x | $SUDO bash - >/dev/null 2>&1
    $SUDO apt-get install -y nodejs >/dev/null 2>&1
    msg_ok "Node.js обновлен до LTS"
}

# Изолированная установка в /opt
sys_install_tool() {
    NAME=$1
    PKG=$2
    CMD=$3
    DIR="/opt/$CMD"

    msg_start "Установка $NAME"

    # 1. Очистка и создание папки
    $SUDO rm -rf "$DIR" 2>/dev/null
    if ! $SUDO mkdir -p "$DIR"; then
        msg_err "Нет прав на создание $DIR"
    fi

    # 2. Установка npm пакета (--prefix)
    if ! $SUDO npm install -g --prefix "$DIR" "$PKG" --loglevel=error >/dev/null 2>&1; then
        msg_err "Ошибка npm install"
    fi

    # 3. Создание симлинка
    TARGET=$(find "$DIR/bin" -type f | head -n 1)

    if [ -f "$TARGET" ]; then
        $SUDO ln -sf "$TARGET" "/usr/local/bin/$CMD"
        msg_ok "$NAME готов ($DIR)"
    else
        msg_err "Бинарник не найден"
    fi
}
