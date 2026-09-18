#!/bin/bash
# AUR installer - elige entre yay o paru

has_yay=$(command -v yay)
has_paru=$(command -v paru)

if [[ -z "$has_yay" && -z "$has_paru" ]]; then
  echo "Error: necesitas yay o paru para usar este buscador."
  exit 1
fi

if [[ -n "$has_yay" && -n "$has_paru" ]]; then
  AUR_HELPER=$(printf 'yay\nparu' | fzf \
    --border sharp \
    --color 'pointer:green,marker:green' \
    --header 'Elige el manejador AUR (yay o paru)' \
    --prompt 'Asistente AUR: ')
  [[ -z "$AUR_HELPER" ]] && exit 0
elif [[ -n "$has_yay" ]]; then
  AUR_HELPER=yay
else
  AUR_HELPER=paru
fi

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
  --header 'Instalador de Paquetes AUR - Selecciona con Tab, Enter para revisar'
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