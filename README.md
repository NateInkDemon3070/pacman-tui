# pacman-tui

Un par de buscadores con fuzzy finder/fzf para instalar paquetes de **pacman** y del **AUR**, sin salirte de la terminal. Algo al estilo de las herramientas que trae Omarchy, pero con un toque más propio.

**pacfetch** lista todos los paquetes de los repos oficiales:

![Buscador de paquetes pacman](assets/2026-09-18_15-52.png)

**aurfetch** hace lo mismo con el AUR, pero si tenés instalados *yay* y *paru* te deja elegir cuál usar:

![Buscador de apps para el desinstalador](assets/2026-09-18_15-53.png)

## Qué hace

- **`pacfetch`** — Todos los paquetes de los repos, con preview de `pacman -Si` y multi-selección con `Tab`.
- **`aurfetch`** — Todo el AUR, con preview y `alt+b` para ver el PKGBUILD antes de instalar. Al elegir siempre te muestra el PKGBUILD y te pide confirmación, porque ya sabemos cómo es el AUR.
- **`pacman`** y **`paru`** — La función `pacman` reemplaza el comando real en tu shell y te da atajos:

| Comando | Qué hace |
|---|---|
| `pacman` | Abre el buscador de paquetes |
| `pacman update` | `pacman -Syu` |
| `pacman uninstall` | Te deja elegir qué desinstalar con fzf |
| `pacman uninstall <paquete>` | Lo borra directo |
| `paru` | Abre el buscador del AUR |

> Si en algún momento necesitás el pacman (o paru) de verdad, usá `command pacman` / `command paru`.

Todo en español, con bordes cuadrados y temas compartidos entre los tres buscadores.

### Elegir entre yay y paru

`aurfetch` se adapta a lo que tengas instalado:

- Solo tenés **yay** → usa yay. Solo tenés **paru** → usa paru.
- Tenés **ambos** → cada vez que lo abras te pregunta cuál usar con un selector.

Aunque no tengas el otro, cambiarlo es fácil: por ejemplo, si vengo usando `paru` y quiero pasar a `yay`, instalá `yay` y la próxima vez te va a ofrecer los dos; si querés fijar uno solo, desinstalá el que no vas a usar.

## Instalación

Primero el paquete (da igual qué shell uses, esto instala todo):

```sh
git clone https://github.com/NateInkDemon3070/pacman-tui
cd pacman-tui
makepkg -si
```

Después activá los atajos según tu shell:

### Fish

No tenés que hacer nada: el paquete instala las funciones en `/usr/share/fish/vendor_functions.d/` y se cargan solas en cada terminal.

### Bash

Agregá esta línea a tu `~/.bashrc`:

```sh
source /usr/share/pacman-tui/pacman.bash
```

### Zsh

Agregá esta línea a tu `~/.zshrc`:

```sh
source /usr/share/pacman-tui/pacman.zsh
```

En ambos casos abrí una terminal nueva (o recargá el archivo con `source ~/.bashrc` / `source ~/.zshrc`) y ya podés usar `pacman`, `paru`, `pacfetch` y `aurfetch`.

### Requisitos

- `fzf`, `pacman`, `curl`, `less`
- `yay` o `paru` (solo para el AUR)

## Créditos

Esto es un fork adaptado del proyecto de [kantiankant](https://github.com/kantiankant), [Omarchy_installers](https://github.com/kantiankant/Omarchy_installers), que a su vez porta los instaladores de [Omarchy](https://omarchy.org) de DHH. Gracias por el laburo previo. Licencia GPL-3.0.
