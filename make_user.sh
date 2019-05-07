#!/usr/bin/env bash

read -p "Create new user? [y/N] " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]] 
then
  echo "Aborting..."
  [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
fi

read -p "Enter username: " username
read -p "Create user $username? [y/N] " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]] 
then
  echo "Aborting..."
  [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
fi

adduser $username

read -p "Should $username be a sudoer? [y/N] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
  usermod -aG sudo $username
  echo "Added $username to sudoers group."
fi

read -p "Allow current authorised keys to access $username? [y/N] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]] 
then
  mkdir -p /home/$username/.ssh
  cp ~/.ssh/authorized_keys /home/$username/.ssh
  chown -R $username:$username /home/$username/.ssh
  echo "Copied authorized_keys to /home/$username/.ssh"
fi

echo "Done."
[[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
