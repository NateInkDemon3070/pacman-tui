#!/usr/bin/env bash
# Gestor de paquetes estilo pacman-tui para bash.
# Añade a tu ~/.bashrc:  source /usr/share/pacman-tui/bash/pacman.bash

pacman() {
  local pkg
  case "$1" in
    update)
      sudo command pacman -Syu ;;
    uninstall)
      if [[ -n "${2:-}" ]]; then
        sudo command pacman -Rns "${@:2}"
      else
        pkg=$(command pacman -Qq | fzf \
          --multi \
          --preview 'command pacman -Qi {1}' \
          --preview-label='alt-p: ocultar/mostrar preview, alt-j/k: desplazar, tab: multi-seleccion' \
          --preview-label-pos='bottom' \
          --preview-window 'down:65%:wrap:border-sharp' \
          --bind 'alt-p:toggle-preview' \
          --bind 'alt-d:preview-half-page-down,alt-u:preview-half-page-up' \
          --bind 'alt-k:preview-up,alt-j:preview-down' \
          --color 'pointer:green,marker:green' \
          --border sharp \
          --header 'Desinstalador de Paquetes - Selecciona con Tab, Enter para eliminar' \
          --prompt 'Paquete: ')
        if [[ -n "$pkg" ]]; then
          sudo command pacman -Rns $pkg
        fi
      fi ;;
    *)
      pacfetch ;;
  esac
}

alias paru='aurfetch'