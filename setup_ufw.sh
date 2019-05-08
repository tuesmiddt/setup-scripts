#!/usr/bin/env bash

if [[ "$UID" -ne "0" ]]; then
  echo "This script must be run as root (sudo)"
  echo "Aborting..."
  exit 1
fi

read -p "Setup ufw? [Y/n]" -n 1 -r
echo

if [[ $REPLY =~ ^[Nn]$ ]]
then
  echo "Aborting..."
  exit 1
fi

echo "Enabling logs..."
ufw logging on
echo "Done."

echo "Rate limiting ssh connections..."
ufw limit ssh
echo "Done."

mapfile -t app_list < <( ufw app list )
unset app_list[0]

echo "Setting rules for installed services"
for app in "${app_list[@]}"
do
  echo "Service name: $app"
  read -p "Allow? [y/N]" -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
    echo "Allowing $app..."
    ufw allow $app
  else
    echo "Denying $app..."
    ufw deny $app
  fi
done
echo "Done."

read -p "Allow incoming HTTP connections? [y/N]" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
  echo "Allowing HTTP..."
  ufw allow http
else
  echo "Denying HTTP..."
  ufw deny http
fi

read -p "Allow incoming HTTPS connections? [y/N]" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
  echo "Allowing HTTPS..."
  ufw allow https
else
  echo "Denying HTTPS..."
  ufw deny https
fi

echo
echo "Showing changed rules"
ufw show added
echo

read -p "Commit added rules? [y/N]" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
  ufw enable
  ufw reload
fi

echo "Current ufw rules:"
ufw status verbose numbered

read -p "Press any key to continue..." -n 1 -r

echo "Done."
[[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
