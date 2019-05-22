systemctl enable tlp.service
systemctl enable tlp-sleep.service
systemctl mask systemd-rfkill.service
systemctl mask systemd-rfkill.socket

ln -s sysconfig/lightdm.conf /etc/lightdm/lightdm.conf

wget $(curl -s https://api.github.com/repos/jwilm/alacritty/releases/latest | grep browser_download_url | grep '64\.deb' | cut -d '"' -f 4) -O alacritty.deb
dpkg -i alacritty.deb