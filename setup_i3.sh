#!/usr/bin/env bash
source util.sh

sudo mv /usr/bin/ksplashqml /usr/bin/ksplashqml.old

set_link $(realpath wm.sh) "$HOME/.config/plasma-workspace/env/wm.sh"
set_link $(realpath dotfiles/i3/config) "$HOME/.config/i3/config"
set_link $(realpath dotfiles/.i3status.conf) "$HOME/.config/.i3status.conf"
