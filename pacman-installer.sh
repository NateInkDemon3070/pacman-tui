#!/bin/bash
# Fuzzy-finder for installing packages from pacman repos (including CachyOS repos)

fzf_args=(
  --multi
  --preview 'pacman -Si {1} 2>/dev/null'
  --preview-label='alt-p: ocultar/mostrar preview, alt-j/k: desplazar, tab: multi-seleccion'
  --preview-label-pos='bottom'
  --preview-window 'down:65%:wrap:border-sharp'
  --bind 'alt-p:toggle-preview'
  --bind 'alt-d:preview-half-page-down,alt-u:preview-half-page-up'
  --bind 'alt-k:preview-up,alt-j:preview-down'
  --color 'pointer:green,marker:green'
  --border sharp
  --header 'Instalador de Paquetes - Selecciona con Tab, Enter para instalar'
  --prompt 'Paquete: '
)

pkg_names=$(pacman -Slq | fzf "${fzf_args[@]}")

if [[ -n "$pkg_names" ]]; then
  echo "$pkg_names" | tr '\n' ' ' | xargs sudo pacman -S --noconfirm

  echo
  echo "Listo. Presiona una tecla para cerrar..."
  read -rn 1 -s
fi
