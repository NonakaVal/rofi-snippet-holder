#!/bin/bash

ROFI_THEME='
window {
    width: 820px;
}
listview {
    lines: 8;
}
inputbar {
    padding: 5px;
}
'

rofi_menu() {
    local extra_args=()
    [ "$XDG_SESSION_TYPE" = "wayland" ] && extra_args+=("-normal-window")

    rofi -dmenu -i "${extra_args[@]}" -theme-str "$ROFI_THEME" "$@"
}

short_path() {
    local dir="$1"

    if [ "$dir" = "$NOTES_DIR" ]; then
        echo "/"
    else
        echo "${dir#$NOTES_DIR/}"
    fi
}

list_entries() {
    local dir="$1"
    local sort_mode="$2"

    if [ "$dir" != "$NOTES_DIR" ]; then
        printf "← ..\tUP\t%s\n" "$(dirname "$dir")"
    fi

    find "$dir" -mindepth 1 -maxdepth 1 -type d -printf "📁 %f\tDIR\t%p\n" | sort -f

    if [ "$sort_mode" = "recent" ]; then
        find "$dir" -mindepth 1 -maxdepth 1 -type f -name "*.md" -printf "%T@\t%f\tFILE\t%p\n" \
            | sort -rn \
            | cut -f2-
    else
        find "$dir" -mindepth 1 -maxdepth 1 -type f -name "*.md" -printf "%f\tFILE\t%p\n" \
            | sort -f
    fi
}

list_history() {
    local results=""

    while IFS= read -r file; do
        [ -z "$file" ] && continue
        [ ! -f "$file" ] && continue

        local name
        name="$(basename "$file" .md)"
        results="${results}🕐 ${name}\tFILE\t${file}\n"
    done < "$HISTORY_FILE"

    echo -ne "$results"
}

list_favorites() {
    local results=""

    while IFS= read -r file; do
        [ -z "$file" ] && continue
        [ ! -f "$file" ] && continue

        local name
        name="$(basename "$file" .md)"
        results="${results}⭐ ${name}\tFILE\t${file}\n"
    done < "$FAVORITES_FILE"

    echo -ne "$results"
}

show_actions() {
    local file="$1"
    local preview
    local action
    local name
    local fav_marker

    name="$(basename "$file" .md)"
    preview="$(get_snippet_preview "$file")"

    if is_favorite "$file"; then
        fav_marker="⭐"
        action=$(echo -e "Copiar\nEditar\nApagar\nDesfavoritar" | rofi_menu \
            -p "$fav_marker $name" \
            -mesg "$preview")
    else
        action=$(echo -e "Copiar\nEditar\nApagar\nFavoritar" | rofi_menu \
            -p "$name" \
            -mesg "$preview")
    fi

    case "$action" in
        "Copiar")
            local code
            code="$(get_snippet_code "$file")"
            echo -n "$code" | copy_to_clipboard
            add_to_history "$file"
            notify-send "Trechos" "\"$name\" copiado."
            return 99
            ;;
        "Editar")
            "$EDITOR_APP" "$file"
            ;;
        "Apagar")
            confirm_delete "$file"
            ;;
        "Favoritar")
            toggle_favorite "$file"
            ;;
        "Desfavoritar")
            toggle_favorite "$file"
            ;;
    esac
}
