#!/usr/bin/env bash

name="Shaowei Chen"
email="dev@chenshaowei.com"

if [[ ! -f "$HOME/.ssh/id_rsa" ]]
then
  ssh-keygen -t rsa -b 4096 -C "$email"
fi

echo "Setting name and email..."
git config --global user.name "$name"
git config --global user.email "$email"

echo "Done."
