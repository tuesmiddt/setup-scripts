#!/usr/bin/env bash

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
echo 'export PATH="$HOME/bin:$PATH"' >> $HOME/.oh-my-zsh/custom/path.sh
