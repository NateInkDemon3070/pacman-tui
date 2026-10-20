#!/bin/bash
# Buscador de paquetes de los repos con fzf (preview con cache)

cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/pacman-tui"
cache_file="$cache_dir/repo-info"
preview_helper="$cache_dir/preview-info.sh"
mkdir -p "$cache_dir"

# Regenerar el cache solo si falta o si alguna base de datos es mas nueva
if [[ ! -s "$cache_file" ]] || \
   find /var/lib/pacman/sync -maxdepth 1 -name '*.db' -newer "$cache_file" -print -quit 2>/dev/null | grep -q .; then
  pacman -Si > "$cache_file.tmp" 2>/dev/null && mv "$cache_file.tmp" "$cache_file"
fi

cat > "$preview_helper" <<'EOF'
#!/bin/sh
awk -v pkg="$1" '
  BEGIN { RS=""; FS="\n" }
  {
    for (i = 1; i <= NF; i++) {
      if ($i ~ /^(Nombre|Name)[[:space:]]/) {
        pos = index($i, ": ")
        if (pos > 0 && substr($i, pos + 2) == pkg) { print; exit }
      }
    }
  }
' "${PACMAN_TUI_INFO:?}"
EOF
chmod +x "$preview_helper"

fzf_args=(
  --multi
  --preview "PACMAN_TUI_INFO='$cache_file' '$preview_helper' {1}"
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