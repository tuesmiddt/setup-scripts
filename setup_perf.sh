#!/usr/bin/env bash

if [[ "$UID" -ne "0" ]]; then
  echo "This script must be run as root (sudo)"
  echo "Aborting..."
  [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
fi

echo "Installing linux-tools..."
sudo apt-get install linux-tools-common -y
sudo apt-get install linux-tools-generic -y
sudo apt-get install linux-tools-$(uname -r) -y
echo "Done."
