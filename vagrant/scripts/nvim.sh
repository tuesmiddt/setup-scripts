#!/usr/bin/env bash
#
# Important: zsh script must already have been run

# Download latest appimage and make executable
curl -L https://github.com/neovim/neovim/releases/download/stable/nvim.appimage -o $HOME/bin/nvim
chmod u+x bin/nvim

echo 'alias v="nvim"' >> $HOME/.oh-my-zsh/custom/alias.sh
