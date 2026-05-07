#!/bin/bash

set -e

SCRIPT_NAME="snippet-holder"
INSTALL_DIR="$HOME/.local/bin"
LIB_DIR="$INSTALL_DIR/lib"
SOURCE_DIR="$(cd "$(dirname "$0")" && pwd)"

SNIPPET_DIR="${SNIPPET_DIR:-$HOME/Documentos/Notes/01 Snippets}"
EDITOR_APP="${EDITOR_APP:-mousepad}"

echo "=== snippet-holder :: instalador ==="

missing=0

if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    echo "[i] sessao Wayland detectada"

    if command -v rofi >/dev/null 2>&1 && rofi -version 2>/dev/null | grep -qi wayland; then
        echo "[ok] rofi-wayland"
    elif command -v rofi >/dev/null 2>&1; then
        echo "[!] rofi instalado, mas pode nao ter suporte a Wayland."
        echo "    Recomendado: instalar rofi-wayland"
    else
        echo "[x] rofi-wayland nao encontrado"
        missing=1
    fi

    if command -v wl-copy >/dev/null 2>&1; then
        echo "[ok] wl-clipboard"
    else
        echo "[x] wl-clipboard nao encontrado"
        missing=1
    fi
else
    echo "[i] sessao X11 detectada"

    if command -v rofi >/dev/null 2>&1; then
        echo "[ok] rofi"
    else
        echo "[x] rofi nao encontrado"
        missing=1
    fi

    if command -v xclip >/dev/null 2>&1; then
        echo "[ok] xclip"
    else
        echo "[x] xclip nao encontrado"
        missing=1
    fi
fi

if command -v notify-send >/dev/null 2>&1; then
    echo "[ok] libnotify"
else
    echo "[x] libnotify nao encontrado (notify-send)"
    missing=1
fi

if [ "$missing" -eq 1 ]; then
    echo ""
    echo "Instale as dependencias ausentes e rode novamente."
    echo ""
    echo "  Arch/Manjaro:"
    echo "    Wayland:  sudo pacman -S rofi-wayland wl-clipboard libnotify"
    echo "    X11:      sudo pacman -S rofi xclip libnotify"
    echo ""
    echo "  Debian/Ubuntu:"
    echo "    Wayland:  sudo apt install rofi wl-clipboard libnotify-bin"
    echo "    X11:      sudo apt install rofi xclip libnotify-bin"
    echo ""
    echo "  Fedora:"
    echo "    Wayland:  sudo dnf install rofi-wayland wl-clipboard libnotify"
    echo "    X11:      sudo dnf install rofi xclip libnotify"
    exit 1
fi

mkdir -p "$INSTALL_DIR" "$LIB_DIR" "$SNIPPET_DIR"

cp "$SOURCE_DIR/$SCRIPT_NAME" "$INSTALL_DIR/$SCRIPT_NAME"
chmod +x "$INSTALL_DIR/$SCRIPT_NAME"

cp "$SOURCE_DIR/lib/"*.sh "$LIB_DIR/"
chmod +x "$LIB_DIR/"*.sh

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/snippet-holder"
CONFIG_FILE="$CONFIG_DIR/config"

if [ ! -f "$CONFIG_FILE" ]; then
    mkdir -p "$CONFIG_DIR"
    cat > "$CONFIG_FILE" <<EOF
# snippet-holder — configuracao

NOTES_DIR="$SNIPPET_DIR"
EDITOR_APP="$EDITOR_APP"
DEFAULT_SORT="recent"
HISTORY_LIMIT="20"
PREVIEW_LINES="5"
CACHE_TTL="30"
TEMPLATE_DIR="$CONFIG_DIR/templates"
EOF
    echo "[ok] configuracao criada em $CONFIG_FILE"
else
    echo "[i] configuracao existente em $CONFIG_FILE (nao modificada)"
fi

echo ""
echo "[ok] instalado em $INSTALL_DIR/$SCRIPT_NAME"
echo "[ok] modulos em $LIB_DIR/"
echo "[ok] pasta de snippets: $SNIPPET_DIR"
echo "[ok] editor padrao: $EDITOR_APP"
echo ""
echo "Execute: snippet-holder"
