#!/usr/bin/env bash

YAY_PATH=$HOME/yay

git clone https://aur.archlinux.org/yay.git $YAY_PATH
cd $YAY_PATH
makepkg -si
