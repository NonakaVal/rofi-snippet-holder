#!/bin/bash

set -e

SCRIPT_NAME="snippet-holder"
INSTALL_DIR="$HOME/.local/bin"
LIB_DIR="$INSTALL_DIR/lib"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/snippet-holder"
DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/snippet-holder"
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/snippet-holder"

echo "=== snippet-holder :: desinstalador ==="

removed=0

if [ -f "$INSTALL_DIR/$SCRIPT_NAME" ]; then
    rm "$INSTALL_DIR/$SCRIPT_NAME"
    echo "[ok] removido $INSTALL_DIR/$SCRIPT_NAME"
    removed=1
fi

if [ -d "$LIB_DIR" ] && ls "$LIB_DIR"/snippet-holder*.sh >/dev/null 2>&1; then
    rm "$LIB_DIR"/*.sh
    echo "[ok] removidos modulos em $LIB_DIR/"
    removed=1
fi

echo ""
echo "[i] Os seguintes dados NAO foram removidos (preservados para seguranca):"
echo "    - Configuracao: $CONFIG_DIR"
echo "    - Historico/favoritos: $DATA_DIR"
echo "    - Cache: $CACHE_DIR"
echo "    - Pasta de snippets (definida na config)"
echo ""
echo "Para remover tudo manualmente:"
echo "    rm -rf \"$CONFIG_DIR\" \"$DATA_DIR\" \"$CACHE_DIR\""

if [ "$removed" -eq 1 ]; then
    echo ""
    echo "[ok] snippet-holder desinstalado."
else
    echo ""
    echo "[i] snippet-holder nao encontrado em $INSTALL_DIR"
fi
