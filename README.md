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

### Variaveis de configuracao (opcionais)

```bash
SNIPPET_DIR="$HOME/Snippets" EDITOR_APP="nvim" ./install.sh
```

- **SNIPPET_DIR** — onde os snippets ficam salvos (padrao: `~/Documentos/Notes/01 Snippets`)
- **EDITOR_APP** — editor aberto ao criar/editar snippet (padrao: `mousepad`)

## Uso

```bash
snippet-holder
```

| Atalho | Acao |
|---|---|
| `Alt+n` | Novo snippet |
| `Alt+g` | Novo grupo/pasta |
| `Alt+o` | Alternar ordenacao (recentes / A-Z) |
| `Alt+q` | Voltar pasta |
| `Enter` | Abrir snippet |
| `Esc` | Sair |

Ao abrir um snippet: **Copiar**, **Editar** ou **Apagar**.
