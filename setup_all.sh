#!/usr/bin/env bash

sudo mv /usr/bin/ksplashqml /usr/bin/ksplashqml.old

./setup_git.sh
sudo ./pacman.sh install.pacman
./setup_nvim.sh
