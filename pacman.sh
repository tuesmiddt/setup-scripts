#!/usr/bin/env bash

if [[ "$UID" -ne "0" ]]
then
  echo "This script must be run as root (sudo)."
  echo "Aborting..."
  exit 1
fi

if [[ -z $1 ]]
then
  echo "Cannot run script without package list file."
  echo "Aborting..."
  exit 1
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

  # Handle multiple packages in a row (space delimited), split row by whitespace then process each element
  readarray -td '' pkgs < <(awk '{ gsub(/[[:space:]]+/,"\0"); print; }' <<<"$line");
  for pkg in "${pkgs[@]}"
  do
    pending_pkgs=("${pending_pkgs[@]}" "$pkg")
  done
done

echo "Updating package lists..."
pacman -Sy
echo "Done."

echo "Upgrading existing packages..."
pacman -Syu
echo "Done."

echo "Installing packages..."
echo

pkgs=$(echo ${pending_pkgs[@]})
pacman -S $pkgs

echo "Done."
