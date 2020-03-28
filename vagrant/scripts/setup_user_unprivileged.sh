#!/usr/bin/env bash
#
# Vagrant only allows one script per trigger so everything's here

function setup_zsh {
  echo "Setting up zsh..."
  # Install zsh
  sudo apt-get install zsh -y

  # Install oh-my-zsh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

  # Install pure-prompt
  mkdir -p "$HOME/.zsh"
  git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"
  sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME=""/g' $HOME/.zshrc
  echo 'fpath+=("$HOME/.zsh/pure")' >> $HOME/.zshrc
  echo 'autoload -U promptinit; promptinit' >> $HOME/.zshrc
  echo 'prompt pure' >> $HOME/.zshrc

  # Change user default shell
  sudo bash -c "chsh -s $(which zsh) $USER"

  # Create a folder for user binaries
  mkdir $HOME/bin
  echo 'export PATH="$HOME/bin:$PATH"' >> $HOME/.oh-my-zsh/custom/path.zsh

  echo "Done."
}

function setup_nvim {
  echo "Setting up neovim..."

  # Download latest appimage and make executable
  curl -L https://github.com/neovim/neovim/releases/download/stable/nvim.appimage -o $HOME/bin/nvim
  chmod u+x bin/nvim

  echo 'alias v="nvim"' >> $HOME/.oh-my-zsh/custom/alias.zsh

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

  echo "Installing vim-plug..."
  curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  echo "Installing nodejs..."
  curl -sL https://deb.nodesource.com/setup_13.x | sudo -E bash -
  sudo apt-get install -y nodejs

  curl https://raw.githubusercontent.com/tuesmiddt/setup-scripts/kde/dotfiles/nvim/init.vim -o $HOME/.config/nvim/init.vim --create-dirs

  sudo apt-get install ctags

  echo "Installing plugins..."
  $HOME/bin/nvim +'PlugUpdate --sync' +qa

  echo "Done."
}

export DEBIAN_FRONTEND=noninteractive

setup_zsh
setup_nvim

echo $1 $2
