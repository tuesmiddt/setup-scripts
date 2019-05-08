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
  if [[ ! $REPLY =~ ^[Nn]$ ]]
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

mv /etc/apt/sources.list /etc/apt/sources.list.bak
echo "Backed up sources to /etc/apt/sources.list.bak"

added=0

for entry in "${entries[@]}"
do
  if [[ $(cat /etc/apt/sources.list.bak | grep "$entry" | wc -l) -eq 0 ]]
  then
    echo $entry >> /etc/apt/sources.list
    added=1
  fi
done

if [[ $added -eq 1 ]]
then
  echo "" >> /etc/apt/sources.list
fi

cat /etc/apt/sources.list.bak >> /etc/apt/sources.list

echo "Finished adding mirrors."
