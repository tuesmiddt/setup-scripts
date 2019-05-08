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

echo "Purging packages..."
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

  # Handle multiple packages in a row (space delimited), split row by whitespace then process each element
  readarray -td '' pkgs < <(awk '{ gsub(/[[:space:]]+/,"\0"); print; }' <<<"$line");
  for pkg in "${pkgs[@]}"
  do
    apt-get purge $pkg -y

    if [[ $? -eq 0 ]]
    then
      echo "Successfully purged $pkg"
    else
      echo "Error purging $pkg"
      failed_pkgs=("${failed_pkgs[@]}" "$pkg")
    fi
  done
done

if [[ "${#failed_pkgs[@]}" -ne 0 ]]
then
  echo "Failed to purge some packages:"
  echo "${failed_pkgs[@]}"
fi

echo "Done."
