#!/usr/bin/env bash

./setup_git.sh

sudo ./setup_ufw.sh

sudo ./setup_apt_mirrors.sh
sudo ./install_packages.sh apt_install.list
sudo ./setup_perf.sh

sudo ./setup_yarn.sh
./setup_nvim.sh

./setup_zsh.sh
