#!/bin/bash
set -euo pipefail

# Используем sudo, если скрипт запущен не от root
SUDO=""
[[ "$EUID" -ne 0 ]] && SUDO="sudo"

# =========================================================
# CLI — описание доступных инструментов
# =========================================================
CLI_IDS=(koda qwen gemini codex)

declare -A CLI_NAME   # Человекочитаемое имя
declare -A CLI_PKG    # npm-пакет
declare -A CLI_CMD    # Имя бинарника

CLI_NAME[koda]="Koda CLI"
CLI_NAME[qwen]="Qwen CLI"
CLI_NAME[gemini]="Gemini CLI"
CLI_NAME[codex]="Codex CLI"

CLI_PKG[koda]="@kodadev/koda-cli"
CLI_PKG[qwen]="@qwen-code/qwen-code"
CLI_PKG[gemini]="@google/gemini-cli"
CLI_PKG[codex]="@openai/codex"

CLI_CMD[koda]="koda"
CLI_CMD[qwen]="qwen"
CLI_CMD[gemini]="gemini"
CLI_CMD[codex]="codex"

# =========================================================
# DETECT OS — определение дистрибутива и пакетного менеджера
# =========================================================
OS_ID=""
PKG_MGR=""

sys_detect_os() {
    # /etc/os-release — стандартный источник информации о дистрибутиве
    [[ -f /etc/os-release ]] || msg_err "Не удалось определить ОС"

    # shellcheck disable=SC1091
    . /etc/os-release

    OS_ID="$ID"

    case "$ID" in
        ubuntu|debian)
            PKG_MGR="apt"
            ;;
        fedora|rhel|centos|almalinux|rocky)
            PKG_MGR="dnf"
            ;;
        *)
            msg_err "Дистрибутив не поддерживается: $ID"
            ;;
    esac
}

# =========================================================
# UTILS — общие вспомогательные функции
# =========================================================

# Проверяет, доступна ли команда в PATH
cli_is_installed() {
    command -v "$1" >/dev/null 2>&1
}

# Унифицированная установка системных пакетов
sys_install_pkgs() {
    case "$PKG_MGR" in
        apt)
            $SUDO apt-get update -y
            $SUDO apt-get install -y "$@"
            ;;
        dnf)
            $SUDO dnf install -y "$@"
            ;;
    esac
}

# =========================================================
# NODE.JS — проверка и установка Node.js >= 20
# =========================================================
sys_check_node() {
    msg_start "Проверка Node.js"

    # Если Node.js уже установлен и версия подходит — ничего не делаем
    if command -v node >/dev/null 2>&1; then
        VER=$(node -v | sed 's/v//' | cut -d. -f1)
        if [[ "$VER" -ge 20 ]]; then
            msg_ok
            return
        fi
    fi

    msg_ok
    msg_start "Установка Node.js 20"

    # NodeSource сам определяет deb / rpm
    curl -fsSL https://deb.nodesource.com/setup_20.x | $SUDO bash - 2>/dev/null || \
    curl -fsSL https://rpm.nodesource.com/setup_20.x | $SUDO bash -

    # Установка nodejs через пакетный менеджер
    sys_install_pkgs nodejs

    msg_ok
}

# =========================================================
# INSTALL CLI — установка выбранных инструментов в /opt
# =========================================================
sys_install_tool() {
    local id="$1"
    local NAME="${CLI_NAME[$id]}"
    local PKG="${CLI_PKG[$id]}"
    local CMD="${CLI_CMD[$id]}"
    local DIR="/opt/$CMD"
    local BIN="$DIR/node_modules/.bin/$CMD"

    # Если CLI уже доступна в системе — пропускаем
    if cli_is_installed "$CMD"; then
        msg_ok "$NAME уже установлен — пропуск"
        return
    fi

    msg_start "Установка $NAME"

    # Создаём изолированную директорию в /opt
    $SUDO mkdir -p "$DIR"
    $SUDO chown -R "$USER":"$USER" "$DIR"

    # Установка npm-пакета локально
    npm install "$PKG" --prefix "$DIR" --silent

    # Проверяем наличие бинарника
    [[ -x "$BIN" ]] || msg_err "Бинарник $CMD не найден"

    # Делаем CLI доступной глобально
    $SUDO ln -sf "$BIN" "/usr/local/bin/$CMD"

    msg_ok
}
