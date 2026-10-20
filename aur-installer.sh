#!/bin/bash
# AUR installer - elige entre yay o paru y recuerda el predeterminado

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/pacman-tui"
CONFIG_FILE="$CONFIG_DIR/aur-helper"

valid_helper() {
  [[ "$1" == "yay" || "$1" == "paru" ]] && command -v "$1" >/dev/null 2>&1
}

case "$1" in
  -h|--help)
    cat <<'EOF'
Uso: aurfetch [opciones]

  --set-helper yay|paru   Guarda el asistente AUR por defecto
  --reset-helper          Olvida el predeterminado (vuelve a preguntar si hay ambos)
  -h, --help              Muestra esta ayuda
EOF
    exit 0 ;;
  --set-helper)
    if valid_helper "$2"; then
      mkdir -p "$CONFIG_DIR" && echo "$2" > "$CONFIG_FILE"
      echo "Asistente AUR predeterminado: $2"
      exit 0
    else
      echo "Error: '$2' no es válido o no está instalado."
      exit 1
    fi ;;
  --reset-helper)
    rm -f "$CONFIG_FILE"
    echo "Predeterminado eliminado."
    exit 0 ;;
esac

helper="${PACMAN_TUI_AUR_HELPER:-$(cat "$CONFIG_FILE" 2>/dev/null)}"
valid_helper "$helper" || helper=""

has_yay=$(command -v yay)
has_paru=$(command -v paru)

if [[ -z "$has_yay" && -z "$has_paru" ]]; then
  echo "Error: necesitas yay o paru para usar este buscador."
  exit 1
fi

if [[ -z "$helper" ]]; then
  if [[ -n "$has_yay" && -n "$has_paru" ]]; then
    helper=$(printf 'yay\nparu' | fzf \
      --border sharp \
      --color 'pointer:green,marker:green' \
      --header 'Elige el manejador AUR (yay o paru)' \
      --prompt 'Asistente AUR: ')
    [[ -z "$helper" ]] && exit 0
    mkdir -p "$CONFIG_DIR" && echo "$helper" > "$CONFIG_FILE"
  elif [[ -n "$has_yay" ]]; then
    helper=yay
  else
    helper=paru
  fi
fi

AUR_HELPER="$helper"

fzf_args=(
  --multi
  --preview "$AUR_HELPER -Si {1} 2>/dev/null"
  --preview-label='alt-p: ocultar/mostrar preview, alt-b/B: PKGBUILD, alt-j/k: desplazar, tab: multi-seleccion'
  --preview-label-pos='bottom'
  --preview-window 'down:65%:wrap:border-sharp'
  --bind 'alt-p:toggle-preview'
  --bind 'alt-d:preview-half-page-down,alt-u:preview-half-page-up'
  --bind 'alt-k:preview-up,alt-j:preview-down'
  --bind "alt-b:change-preview:$AUR_HELPER -Gpa {1} 2>/dev/null | tail -n +5"
  --bind "alt-B:change-preview:$AUR_HELPER -Si {1} 2>/dev/null"
  --color 'pointer:green,marker:green'
  --border sharp
  --header "Instalador de Paquetes AUR ($AUR_HELPER) - Selecciona con Tab, Enter para revisar"
  --prompt 'Paquete: '
)

pkg_names=$(curl -fsSL "https://aur.archlinux.org/packages.gz" | gzip -dc | fzf "${fzf_args[@]}")

if [[ -n "$pkg_names" ]]; then
  for pkg in $pkg_names; do
    echo "=== PKGBUILD de $pkg ==="
    "$AUR_HELPER" -Gpa "$pkg" 2>/dev/null | less -R
    read -r -p "Instalar $pkg? [y/N] " ans
    case "$ans" in
      [yY]*) "$AUR_HELPER" -S "$pkg" ;;
      *) echo "Saltado: $pkg" ;;
    esac
  done

  echo
  echo "Listo. Presiona una tecla para cerrar..."
  read -rn 1 -s
fi