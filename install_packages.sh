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

echo "Updating package lists..."
apt-get update
echo "Done."

echo "Upgrading existing packages..."
apt-get upgrade -y
echo "Done."

echo "Installing packages..."
failed_pkgs=()

mapfile pkg_list < $1

for line in "${pkg_list[@]}"
do
  # Remove leading/trailing whitespace
  line="$(echo -e "${line}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"

  # Continue if comment or empty
  if [[ $line == \#* ]] || [[ -z $line ]]
  then
    continue
  fi

  echo "Processing line: $line"

  # Handle PPAs
  if [[ $line == ppa:* ]]
  then
    echo "Adding PPA: $line"
    add-apt-repository $line
    apt-get update
    continue
  fi

  # Handle multiple packages in a row (space delimited), split row by whitespace then process each element
  readarray -td '' pkgs < <(awk '{ gsub(/[[:space:]]+/,"\0"); print; }' <<<"$line");
  for pkg in "${pkgs[@]}"
  do
    apt-get install $pkg -y

    if [[ $? -eq 0 ]]
    then
      echo "Successfully installed $pkg"
    else
      echo "Error installing $pkg"
      failed_pkgs=("${failed_pkgs[@]}" "$pkg")
    fi
  done
done

if [[ "${#failed_pkgs[@]}" -ne 0 ]]
then
  echo "Failed to install some packages:"
  echo "${failed_pkgs[@]}"
fi

echo "Done."
