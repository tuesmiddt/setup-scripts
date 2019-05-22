sudo apt-get install --no-install-recommends xorg lightdm -y
sudo apt-get install slick-greeter i3 compton xsettingsd lxappearance scrot network-manager blueman xclip i3-wm dunst i3lock i3status suckless-tools vim wget curl -y

sudo apt-get install tlp -y
systemctl enable tlp.service
systemctl enable tlp-sleep.service
systemctl mask systemd-rfkill.service
systemctl mask systemd-rfkill.socket

apt-get install xfce4-power-manager clipit pulseaudio pavucontrol at-spi2-core pcmanfm firefox chromium-browser xclip -y

ln -s sysconfig/lightdm.conf /etc/lightdm/lightdm.conf

wget $(curl -s https://api.github.com/repos/jwilm/alacritty/releases/latest | grep browser_download_url | grep '64\.deb' | cut -d '"' -f 4) -O alacritty.deb
dpkg -i alacritty.deb