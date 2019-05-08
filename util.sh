#!/usr/bin/env bash

# Usage: link_file source_realpath target_path
set_link () {
  echo "Setting $2"
  target_dir=$(dirname $2)
  if [[ ! -d "$target_dir" ]]
  then
    mkdir -p $target_dir
  fi

  if [[ -L "$2" ]]
  then
    current_link=$(realpath $(readlink $2))

    if [[ $1 = $current_link ]]
    then
      return
    fi
    echo "$2 symlink already exists."
    echo "$2 currently linked to $current_link"

    echo "Removing current link"
    rm $2
  elif [[ -f "$2" ]]
  then
    echo "$2 already exists."
    echo "Backing up to $2.bak"
    cp $2 $2.bak
    rm $2
  fi

  ln -s $1 $2
}
