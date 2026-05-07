#!/bin/bash

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/snippet-holder"
CONFIG_FILE="$CONFIG_DIR/config"
DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/snippet-holder"
HISTORY_FILE="$DATA_DIR/history"
FAVORITES_FILE="$DATA_DIR/favorites"
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/snippet-holder"

load_config() {
    if [ -f "$CONFIG_FILE" ]; then
        source "$CONFIG_FILE"
    fi

    NOTES_DIR="${NOTES_DIR:-$HOME/Documentos/Notes/01 Snippets}"
    EDITOR_APP="${EDITOR_APP:-mousepad}"
    DEFAULT_SORT="${DEFAULT_SORT:-recent}"
    HISTORY_LIMIT="${HISTORY_LIMIT:-20}"
    PREVIEW_LINES="${PREVIEW_LINES:-5}"
    CACHE_TTL="${CACHE_TTL:-30}"
    TEMPLATE_DIR="${TEMPLATE_DIR:-$CONFIG_DIR/templates}"
}

ensure_dirs() {
    mkdir -p "$NOTES_DIR" "$DATA_DIR" "$CACHE_DIR" "$CONFIG_DIR" "$TEMPLATE_DIR"
    touch "$HISTORY_FILE" "$FAVORITES_FILE"
}

write_default_config() {
    if [ ! -f "$CONFIG_FILE" ]; then
        cat > "$CONFIG_FILE" <<EOF
# snippet-holder — configuracao

NOTES_DIR="$HOME/Documentos/Notes/01 Snippets"
EDITOR_APP="mousepad"
DEFAULT_SORT="recent"
HISTORY_LIMIT="20"
PREVIEW_LINES="5"
CACHE_TTL="30"
TEMPLATE_DIR="$CONFIG_DIR/templates"
EOF
    fi
}
