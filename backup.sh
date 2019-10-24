#!/usr/bin/env bash

# Backup foreign packages. Usually refers to just AUR packages.
pacman -Qqm > aurlist.txt

# Backup non-foreign packages.
pacman -Qqe | grep -v "$(pacman -Qqm)" > pkglist.txt
