#!/usr/bin/env bash
source util.sh

# set_link $(realpath dotfiles/.vimrc) "$HOME/.vimrc"

TARGET="$HOME/bin"

if [[ ! -d "$TARGET" ]]
then
  mkdir "$TARGET"
fi

bash -c "cd $TARGET && curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage"
chmod u+x "$TARGET/nvim.appimage"

set_link $(realpath dotfiles/init.vim) "$HOME/.config/nvim/init.vim"

python3 -m pip install --user --upgrade pynvim
