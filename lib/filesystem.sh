#!/bin/bash

safe_filename() {
    echo "$1" | tr -cd '[:alnum:] _-[]()' | sed 's/[ ]*$//'
}

safe_dirname() {
    echo "$1" | tr -cd '[:alnum:] _-[]()' | sed 's/[ ]*$//'
}

get_snippet_code() {
    local file="$1"

    awk '
        /^```/ {
            count++
            if (count == 1) next
            if (count == 2) exit
        }
        count == 1 { print }
    ' "$file"
}

get_snippet_tags() {
    local file="$1"
    local in_tags=0

    while IFS= read -r line; do
        if [ "$in_tags" -eq 0 ] && echo "$line" | grep -q '^tags:'; then
            in_tags=1
            echo "$line" | sed 's/^tags:[ ]*//' | sed 's/^\[//;s/\]$//' | tr ',' '\n' | sed 's/^[ ]*//;s/[ ]*$//' | grep -v '^$'
            continue
        fi
        if [ "$in_tags" -eq 1 ]; then
            if echo "$line" | grep -q '^[^ ]*- '; then
                echo "$line" | sed 's/^[ ]*- //' | sed 's/[ ]*$//'
            else
                break
            fi
        fi
    done < "$file"
}

get_snippet_title() {
    local file="$1"
    grep '^title:' "$file" 2>/dev/null | head -1 | sed 's/^title:[ ]*//' | sed "s/^['\"]//;s/['\"]$//"
}

get_snippet_preview() {
    local file="$1"
    local code
    local lines

    code="$(get_snippet_code "$file")"

    lines=$(echo "$code" | head -n "$PREVIEW_LINES" | while IFS= read -r line; do
        echo "$line" | tr '\r' ' ' | sed 's/\t/    /g' | cut -c 1-80
    done)

    local total
    total=$(echo "$code" | wc -l)
    if [ "$total" -gt "$PREVIEW_LINES" ]; then
        lines="$(echo "$lines"; echo "  ... (+$((total - PREVIEW_LINES)) linhas)")"
    fi

    echo "$lines"
}

find_all_snippets() {
    find "$NOTES_DIR" -type f -name "*.md" -print0 2>/dev/null | sort -z
}

search_by_tag() {
    local tag="$1"
    local results=""

    while IFS= read -r -d '' file; do
        local tags
        tags="$(get_snippet_tags "$file")"
        if echo "$tags" | grep -qi "$tag"; then
            local name
            local relpath
            name="$(basename "$file" .md)"
            relpath="${file#$NOTES_DIR/}"
            relpath="$(dirname "$relpath")"
            [ "$relpath" = "." ] && relpath="/"
            results="${results}${name}\tFILE\t${file}\n"
        fi
    done < <(find_all_snippets)

    echo -ne "$results"
}

search_global() {
    local query="$1"
    local results=""

    while IFS= read -r -d '' file; do
        if grep -qi "$query" "$file" 2>/dev/null; then
            local name
            local relpath
            name="$(basename "$file" .md)"
            relpath="${file#$NOTES_DIR/}"
            relpath="$(dirname "$relpath")"
            [ "$relpath" = "." ] && relpath="/"
            results="${results}${name}\tFILE\t${file}\n"
        fi
    done < <(find_all_snippets)

    echo -ne "$results"
}

export_snippets() {
    local dest="$1"
    local timestamp
    timestamp=$(date +%Y%m%d_%H%M%S)
    local archive="$dest/snippet-holder-export-${timestamp}.tar.gz"

    tar -czf "$archive" -C "$(dirname "$NOTES_DIR")" "$(basename "$NOTES_DIR")" 2>/dev/null
    notify-send "Trechos" "Exportado para: $archive"
    echo "$archive"
}

import_snippets() {
    local archive="$1"
    local count_before
    local count_after

    count_before=$(find "$NOTES_DIR" -type f -name "*.md" | wc -l)

    tar -xzf "$archive" -C "$(dirname "$NOTES_DIR")" 2>/dev/null

    count_after=$(find "$NOTES_DIR" -type f -name "*.md" | wc -l)
    local added=$((count_after - count_before))

    notify-send "Trechos" "Importados $added snippets."
}
