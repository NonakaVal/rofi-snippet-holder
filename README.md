# rofi-snippet-holder

Gerenciador de trechos de codigo via Rofi. Salve, navegue e copie snippets organizados por pastas, direto do menu do Rofi.

## Dependencias

### Obrigatorio

| Pacote | Comando | Funcao |
|---|---|---|
| `rofi` | `rofi` | Menu interativo (X11) |
| `rofi-wayland` | `rofi` | Menu interativo (Wayland) |
| `xclip` | `xclip` | Area de transferencia (X11) |
| `wl-clipboard` | `wl-copy` / `wl-paste` | Area de transferencia (Wayland) |
| `libnotify` | `notify-send` | Notificacoes de acoes |

> Wayland precisa de `rofi-wayland` + `wl-clipboard`. X11 precisa de `rofi` + `xclip`. `libnotify` e necessario em ambos.

### Instalacao das dependencias

**Arch / Manjaro**
```bash
# Wayland
sudo pacman -S rofi-wayland wl-clipboard libnotify

# X11
sudo pacman -S rofi xclip libnotify
```

**Debian / Ubuntu**
```bash
# Wayland
sudo apt install rofi wl-clipboard libnotify-bin

# X11
sudo apt install rofi xclip libnotify-bin
```

**Fedora**
```bash
# Wayland
sudo dnf install rofi-wayland wl-clipboard libnotify

# X11
sudo dnf install rofi xclip libnotify
```

## Instalar

```bash
git clone git@github.com:NonakaVal/rofi-snippet-holder.git
cd rofi-snippet-holder
./install.sh
```

O instalador detecta automaticamente Wayland ou X11 e verifica as dependencias.

### Variaveis de configuracao (opcionais, primeira instalacao)

```bash
SNIPPET_DIR="$HOME/Snippets" EDITOR_APP="nvim" ./install.sh
```

- **SNIPPET_DIR** — onde os snippets ficam salvos (padrao: `~/Documentos/Notes/01 Snippets`)
- **EDITOR_APP** — editor aberto ao criar/editar snippet (padrao: `mousepad`)

> Apos a primeira instalacao, edite o arquivo de configuracao diretamente.

## Configuracao

O arquivo de configuracao fica em `~/.config/snippet-holder/config`:

```bash
NOTES_DIR="$HOME/Documentos/Notes/01 Snippets"
EDITOR_APP="mousepad"
DEFAULT_SORT="recent"      # "recent" ou "az"
HISTORY_LIMIT="20"          # max snippets no historico
PREVIEW_LINES="5"           # linhas mostradas no preview
CACHE_TTL="30"              # TTL do cache (em segundos)
TEMPLATE_DIR="~/.config/snippet-holder/templates"
```

## Uso

```bash
snippet-holder
```

### Menu principal

| Opcao | Descricao |
|---|---|
| Navegar | Navegar pelas pastas de snippets |
| Buscar | Busca global em conteudo de todos os snippets |
| Buscar por tag | Filtrar snippets por tag (do frontmatter) |
| Historico | Ultimos snippets copiados |
| Favoritos | Snippets marcados como favoritos |
| Exportar | Exportar todos os snippets como tar.gz |
| Importar | Importar snippets de um arquivo tar.gz |

### Navegacao (dentro de uma pasta)

| Atalho | Acao |
|---|---|
| `Alt+n` | Novo snippet |
| `Alt+g` | Novo grupo/pasta |
| `Alt+o` | Alternar ordenacao (recentes / A-Z) |
| `Alt+q` | Voltar pasta |
| `Enter` | Abrir snippet |
| `Esc` | Sair |

### Acoes de snippet

Ao abrir um snippet: **Copiar**, **Editar**, **Apagar**, **Favoritar** (ou **Desfavoritar**).

## Templates

Snippets sao criados a partir de templates. O diretorio de templates fica em `~/.config/snippet-holder/templates/`.

Tres templates sao criados automaticamente:

- **default.md** — template padrao com bloco de codigo
- **function.md** — template para funcoes (javascript)
- **notes.md** — template para anotacoes

### Criar template customizado

Crie um arquivo `.md` no diretorio de templates com as variaveis:

| Variavel | Descricao |
|---|---|
| `{{TITLE}}` | Nome do snippet |
| `{{DATE}}` | Data de criacao (YYYY-MM-DD) |
| `{{CLIPBOARD}}` | Conteudo da area de transferencia |

Exemplo (`~/.config/snippet-holder/templates/python.md`):

```markdown
---
title: {{TITLE}}
tags:
  - python
dateCreated: "[[{{DATE}}]]"
---

```python
{{CLIPBOARD}}
```
```

## Desinstalar

```bash
snippet-holder-uninstall
```

O script remove apenas os binarios e modulos. Dados (configuracao, historico, favoritos, snippets) sao preservados. Para remover tudo:

```bash
rm -rf ~/.config/snippet-holder ~/.local/share/snippet-holder ~/.cache/snippet-holder
```

## Estrutura do projeto

```
snippet-holder          # Script principal
lib/
  config.sh             # Configuracao e inicializacao
  clipboard.sh          # Area de transferencia, historico, favoritos
  filesystem.sh         # Leitura de arquivos, busca, import/export
  rofi_ui.sh            # Interface Rofi, listagens, acoes
  snippets.sh           # Criacao/edicao de snippets, templates
install.sh              # Instalador
uninstall.sh            # Desinstalador
```

## Dados

| Dado | Localizacao |
|---|---|
| Configuracao | `~/.config/snippet-holder/config` |
| Templates | `~/.config/snippet-holder/templates/` |
| Historico | `~/.local/share/snippet-holder/history` |
| Favoritos | `~/.local/share/snippet-holder/favorites` |
| Cache | `~/.cache/snippet-holder/` |
