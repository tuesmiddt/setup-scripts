#!/usr/bin/env bash
source util.sh

# set_link $(realpath dotfiles/.vimrc) "$HOME/.vimrc"

echo "Setting up neovim..."

TARGET="$HOME/bin"

if [[ ! -d "$TARGET" ]]
then
  mkdir "$TARGET"
fi

bash -c "cd $TARGET && curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage"
chmod u+x "$TARGET/nvim.appimage"

set_link $(realpath dotfiles/init.vim) "$HOME/.config/nvim/init.vim"

if [[ ! -d "$HOME/.vimtmp" ]]
then
  echo "Creating tmp dir at ~/.vimtmp"
  mkdir "$HOME/.vimtmp"
fi

echo "Setting up python provider..."
VENV="$HOME/venv"

if [[ ! -d "$VENV" ]]
then
  mkdir "$VENV"
fi

if [[ ! -d "$VENV/py3nvim" ]]
then
  bash -c "cd $VENV && python3 -m venv py3nvim"
  source $VENV/py3nvim/bin/activate
  pip install wheel
  pip install --upgrade pynvim
  deactivate
fi

echo "Setting up node provider..."
yarn global add neovim

echo "Installing vim-plug..."
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
