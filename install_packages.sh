#!/usr/bin/env bash

if [[ "$UID" -ne "0" ]]
then
  echo "This script must be run as root (sudo)."
  echo "Aborting..."
  [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
fi

if [[ -z $1 ]]
then
  echo "Cannot run script without package list file."
  echo "Aborting..."
  [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
fi

file=$1
flags=$2

pending_pkgs=()

mapfile pkg_list < "$file"

echo "Reading $file"

for line in "${pkg_list[@]}"
do
  # Remove leading/trailing whitespace
  line="$(echo -e "${line}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"

  # Continue if comment or empty
  if [[ $line == \#* ]] || [[ -z $line ]]
  then
    continue
  fi

  # echo "Processing line: $line"

  # Handle PPAs
  if [[ $line == ppa:* ]]
  then
    ppa_name=$(echo "$line" | sed s/ppa://)
    if [[ $(grep -q "^deb .*$ppa_name" /etc/apt/sources.list /etc/apt/sources.list.d/* | wc -l) -ne 0 ]]
    then
      echo "Adding PPA: $line"
      add-apt-repository $line
    fi
    continue
  fi

  # Handle multiple packages in a row (space delimited), split row by whitespace then process each element
  readarray -td '' pkgs < <(awk '{ gsub(/[[:space:]]+/,"\0"); print; }' <<<"$line");
  for pkg in "${pkgs[@]}"
  do
    pending_pkgs=("${pending_pkgs[@]}" "$pkg")
  done
done

echo "Updating package lists..."
apt-get update
echo "Done."

echo "Upgrading existing packages..."
apt-get upgrade -y
echo "Done."

echo "Installing packages..."
echo

pkgs=$(echo ${pending_pkgs[@]})
echo "apt-get install $2 $pkgs -y"

echo "Done."
