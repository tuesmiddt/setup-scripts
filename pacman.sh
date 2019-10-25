#!/usr/bin/env bash

if [[ "$UID" -ne "0" ]]
then
  echo "This script must be run as root (sudo)."
  exec sudo "$0" "$@"
  exit $?
fi

if [[ -z $1 ]]
then
  echo "Cannot run script without package list file."
  echo "Aborting..."
  exit 1
fi

echo "Updating package lists..."
pacman -Sy
echo "Done."

echo "Upgrading existing packages..."
pacman -Syu
echo "Done."

echo "Installing packages..."
pacman -S --needed - < $1
echo

echo "Done."
