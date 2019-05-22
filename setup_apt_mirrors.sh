#!/usr/bin/env bash

if [[ "$UID" -ne "0" ]]
then
    echo "This script must be run as root (sudo)."
    echo "Aborting..."
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
fi

codename=$(lsb_release -c -s)
echo "Adding mirrors"

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
