#!/usr/bin/env bash

# read -p "Set ufw rules? [y/N] " -n 1 -r
# echo
# if [[ ! $REPLY =~ ^[Yy]$ ]] 
# then
#   echo "Aborting..."
#   [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
# fi
if [[ "$UID" -ne "0" ]]; then
  echo "This script must be run as root (sudo)"
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

echo "Updating package lists..."
apt-get update
echo "Done."

echo "Installing packages..."
failed_pkgs=()

mapfile pkg_list < ./pkg_list

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

  read -p "Press any key to continue..." -n 2 -r
fi

echo "Done."
[[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
