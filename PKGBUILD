# Maintainer: jpablo
pkgname=pacman-tui
pkgver=1.0.0
pkgrel=1
pkgdesc="Buscadores fuzzy TUI para pacman y AUR con soporte para yay o paru, integrados como subcomandos (update/uninstall) y funciones para fish, bash y zsh"
arch=('any')
url="https://github.com/NateInkDemon3070/pacman-tui"
license=('GPL-3.0-or-later')
depends=('fzf' 'pacman' 'curl' 'less')
optdepends=(
  'paru: for AUR package installation'
  'yay: for AUR package installation'
)
source=(
  'pacman-installer.sh'
  'aur-installer.sh'
  'pacman.fish'
  'paru.fish'
  'pacman.bash'
  'pacman.zsh'
)
sha256sums=(
  'SKIP'
  'SKIP'
  'SKIP'
  'SKIP'
  'SKIP'
  'SKIP'
)

package() {
  install -Dm755 pacman-installer.sh "${pkgdir}/usr/bin/pacfetch"
  install -Dm755 aur-installer.sh "${pkgdir}/usr/bin/aurfetch"
  install -Dm644 pacman.fish "${pkgdir}/usr/share/fish/vendor_functions.d/pacman.fish"
  install -Dm644 paru.fish "${pkgdir}/usr/share/fish/vendor_functions.d/paru.fish"
  install -Dm644 pacman.bash "${pkgdir}/usr/share/pacman-tui/pacman.bash"
  install -Dm644 pacman.zsh "${pkgdir}/usr/share/pacman-tui/pacman.zsh"
}