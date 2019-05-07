#!/usr/bin/env bash

if [[ "$UID" -ne "0" ]]
then
  echo "This script must be run as root (sudo)."
  echo "Aborting..."
  [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
fi

echo "Adding mirrors"
codename=$(cat /etc/os-release | grep "VERSION_CODENAME" | sed s/^.*=//)
echo "Found codename: $codename"
while [[ true ]]
do
  read -p "Is this correct? [Y/n] " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
    break
  else
    read -p "Please enter release codename: " codename
    echo "You entered: $codename"
  fi
done

echo "Adding the following entries to /etc/apt/sources.list"

entries=(
"deb mirror://mirrors.ubuntu.com/mirrors.txt $codename main restricted universe multiverse"
"deb mirror://mirrors.ubuntu.com/mirrors.txt $codename-updates main restricted universe multiverse"
"deb mirror://mirrors.ubuntu.com/mirrors.txt $codename-backports main restricted universe multiverse"
"deb mirror://mirrors.ubuntu.com/mirrors.txt $codename-security main restricted universe multiverse"
)

for entry in "${entries[@]}"
do
  echo $entry
done

read -p "Continue? [y/N] " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
  mv /etc/apt/sources.list /etc/apt/sources.list.bak
  echo "Backed up sources to /etc/apt/sources.list.bak"

  for entry in "${entries[@]}"
  do
    echo $entry >> /etc/apt/sources.list
  done
  echo "" >> /etc/apt/sources.list

  cat /etc/apt/sources.list.bak >> /etc/apt/sources.list

  echo "Finished adding mirrors."
else
  "Skipped adding mirrors."
fi

