# regexghost's dotfiles

This repo contains all my dotfiles, including:
* Configuration for various programs
* Window manager and desktop environment setups
* Terminal, window manager and panel scripts
* Small programs I've written
* Install guides for various OS setups

This repo is a work in progress, as well as standard dotfiles updates I also plan to add scripts which can be used to save/load the dotfiles

More information about specific WM/DE setups can be found below, both the dotfiles themselves and relevant articles on my website

## Window Managers/Desktop Environments

* [JWM (Raspberry Pi)] - [Website](https://www.regexghost.com/linux/jwm)
* [i3](i3/README.md) - [Website](https://www.regexghost.com/linux/i3)
* [KDE](kde/README.md) - [Website](https://www.regexghost.com/linux/kde)

## Colour Schemes

Before loading the dotfiles, navigates to `helpers/colours/` and run `make.sh *colourscheme*`, where `*colourscheme*` is a scheme in `helpers/colours/schemes/` (without the `.sh`)  
This will place relevant colourschemee substitution files in the correct directories to be loaded with the config files. These files aren't tracked in the repo as there a) there is a large number of them and b) they can be generated programatically from the `schemes/` files.
