sudo apt-get install --no-install-recommends xorg lightdm -y
sudo apt-get install slick-greeter i3 compton xsettingsd lxappearance scrot network-manager blueman xclip i3-wm dunst i3lock i3status suckless-tools -y

sudo apt-get install tlp
systemctl enable tlp.service
systemctl enable tlp-sleep.service
systemctl mask systemd-rfkill.service
systemctl mask systemd-rfkill.socket

sudo apt-get install xfce4-power-manager clipit pulseaudio pavucontrol at-spi2-core pcmanfm firefox chromium-browser xclip

ln -s sysconfig/lightdm.conf /etc/lightdm/lightdm.conf
startx &
sleep 1s
kill -9 $!
