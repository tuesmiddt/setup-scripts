#!/usr/bin/env bash
source util.sh

set_link $(realpath dotfiles/alacritty/alacritty.yml) "$HOME/.config/alacritty/alacritty.yml"
set_link $(realpath dotfiles/nvim/init.vim) "$HOME/.config/nvim/init.vim"
set_link $(realpath dotfiles/.tmux.conf) "$HOME/.tmux.conf"
