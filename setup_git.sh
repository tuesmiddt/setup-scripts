#!/usr/bin/env bash

read -p "Setup git? [Y/n]" -n 1 -r
echo

if [[ $REPLY =~ ^[Nn]$ ]]
then
  echo "Aborting..."
  [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
fi

read -p "Enter name: " name
read -p "Enter email: " email

read -p "Create ssh key? [Y/n]" -n 1 -r
echo
if [[ ! $REPLY =~ ^[Nn]$ ]]
then
  ssh-keygen -t rsa -b 4096 -C "$email"
fi

echo "Setting name and email..."
git config --global user.name "$name"
git config --global user.email "$email"

echo "Done."
[[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
