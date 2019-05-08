#!/usr/bin/env bash

if [[ "$UID" -ne "0" ]]; then
  echo "This script must be run as root (sudo)"
  echo "Aborting..."
  [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
fi

echo "Installing yarn..."
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
apt-get update && apt-get install yarn -y
echo "Done."
