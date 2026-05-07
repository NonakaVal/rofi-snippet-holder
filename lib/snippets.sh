#!/bin/bash

create_group() {
    local current_dir="$1"
    local name

    name=$(rofi_menu -p "📁 +grupo")

    [ -z "$name" ] && return 1

    local clean_name
    clean_name="$(safe_dirname "$name")"
    [ -z "$clean_name" ] && return 1

    mkdir -p "$current_dir/$clean_name"
    chmod 755 "$current_dir/$clean_name"
    notify-send "Trechos" "Grupo: $clean_name"

    echo "$current_dir/$clean_name"
}

new_snippet() {
    local current_dir="$1"
    local name
    local file_path
    local template

    name=$(rofi_menu -p "✚ +trecho")

    [ -z "$name" ] && return 1

    local clean_name
    clean_name="$(safe_filename "$name")"
    [ -z "$clean_name" ] && return 1
    file_path="$current_dir/${clean_name}.md"

    if [ -d "$TEMPLATE_DIR" ] && [ "$(ls -A "$TEMPLATE_DIR" 2>/dev/null)" ]; then
        template=$(ls "$TEMPLATE_DIR" | rofi_menu -p "Template (Esc=vazio)")
        if [ -n "$template" ] && [ -f "$TEMPLATE_DIR/$template" ]; then
            local clipboard_content
            clipboard_content="$(read_clipboard)"
            sed -e "s/{{TITLE}}/$name/g" \
                -e "s/{{DATE}}/$DATE_FORMAT/g" \
                -e "s/{{CLIPBOARD}}/$clipboard_content/g" \
                "$TEMPLATE_DIR/$template" > "$file_path"
        else
            _default_snippet "$file_path" "$name"
        fi
    else
        _default_snippet "$file_path" "$name"
    fi

    chmod 644 "$file_path"
    "$EDITOR_APP" "$file_path"
}

_default_snippet() {
    local file_path="$1"
    local name="$2"

    cat > "$file_path" <<EOF
---
title: $name
tags:
  - clipped
dateCreated: "[[$DATE_FORMAT]]"
---

\`\`\`
$(read_clipboard)
\`\`\`
EOF
}

confirm_delete() {
    local file="$1"
    local name
    local check

    name="$(basename "$file" .md)"

    check=$(echo -e "Não\nSim" | rofi_menu -p "Apagar '$name'?")

    if [ "$check" = "Sim" ]; then
        rm "$file"
        notify-send "Trechos" "\"$name\" apagado."
    fi
}

create_default_template() {
    mkdir -p "$TEMPLATE_DIR"

    cat > "$TEMPLATE_DIR/default.md" <<'TMPL'
---
title: {{TITLE}}
tags:
  - clipped
dateCreated: "[[{{DATE}}]]"
---

```
{{CLIPBOARD}}
```
TMPL

    cat > "$TEMPLATE_DIR/function.md" <<'TMPL'
---
title: {{TITLE}}
tags:
  - function
dateCreated: "[[{{DATE}}]]"
---

```javascript
{{CLIPBOARD}}
```
TMPL

    cat > "$TEMPLATE_DIR/notes.md" <<'TMPL'
---
title: {{TITLE}}
tags:
  - notes
dateCreated: "[[{{DATE}}]]"
---

## {{TITLE}}

{{CLIPBOARD}}
TMPL
}
