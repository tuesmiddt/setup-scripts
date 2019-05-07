#!/usr/bin/env bash
source util.sh

ZSH="$HOME/.oh-my-zsh"

which zsh
if [[ $? -ne 0 ]]
then
  echo "Zsh not found."
  echo "Aborting..."
  [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
fi

if [[ -d "$ZSH" ]]
then
  echo "Oh-my-zsh already setup."
  echo "Aborting..."
  [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
fi

echo "Installing oh-my-zsh..."
echo "Enter C-d after oh-my-zsh setup script completes."
bash -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

echo "Installing pure prompt..."
pure_dir="$ZSH/pure"
zfunctions_dir="$ZSH/zfunctions"

git clone https://github.com/sindresorhus/pure.git "$pure_dir"
mkdir "$zfunctions_dir"

ln -s "$pure_dir/pure.zsh" "$zfunctions_dir/prompt_pure_setup"
ln -s "$pure_dir/async.zsh" "$zfunctions_dir/async"

echo "Installing zsh-autosuggestions..."
git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH/custom/plugins/zsh-autosuggestions"

echo "Linking .zshrc"
set_link $(realpath dotfiles/.zshrc) "$HOME/.zshrc"
