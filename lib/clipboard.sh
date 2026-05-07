#!/bin/bash

copy_to_clipboard() {
    if command -v wl-copy >/dev/null 2>&1 && [ "$XDG_SESSION_TYPE" = "wayland" ]; then
        wl-copy
    elif command -v xclip >/dev/null 2>&1; then
        xclip -selection clipboard
    elif command -v wl-copy >/dev/null 2>&1; then
        wl-copy
    else
        notify-send "Trechos" "Instale xclip ou wl-clipboard."
        return 1
    fi
}

read_clipboard() {
    if command -v wl-paste >/dev/null 2>&1 && [ "$XDG_SESSION_TYPE" = "wayland" ]; then
        wl-paste 2>/dev/null
    elif command -v xclip >/dev/null 2>&1; then
        xclip -o -selection clipboard 2>/dev/null
    elif command -v wl-paste >/dev/null 2>&1; then
        wl-paste 2>/dev/null
    fi
}

add_to_history() {
    local file="$1"
    local name
    name="$(basename "$file" .md)"

    grep -vFx "$file" "$HISTORY_FILE" 2>/dev/null > "$HISTORY_FILE.tmp" || true
    echo "$file" | cat - "$HISTORY_FILE.tmp" > "$HISTORY_FILE"
    head -n "$HISTORY_LIMIT" "$HISTORY_FILE" > "$HISTORY_FILE.tmp"
    mv "$HISTORY_FILE.tmp" "$HISTORY_FILE"
}

toggle_favorite() {
    local file="$1"

    if grep -qFx "$file" "$FAVORITES_FILE" 2>/dev/null; then
        grep -vFx "$file" "$FAVORITES_FILE" > "$FAVORITES_FILE.tmp" || true
        mv "$FAVORITES_FILE.tmp" "$FAVORITES_FILE"
        notify-send "Trechos" "Removido dos favoritos."
        return 1
    else
        echo "$file" >> "$FAVORITES_FILE"
        notify-send "Trechos" "Adicionado aos favoritos."
        return 0
    fi
}

is_favorite() {
    local file="$1"
    grep -qFx "$file" "$FAVORITES_FILE" 2>/dev/null
}
