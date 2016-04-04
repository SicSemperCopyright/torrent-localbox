#!/bin/bash

set -euo pipefail

VAGRANT_USER=ubuntu

sudo DEBIAN_FRONTEND=noninteractive apt-get update &&
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
    iptables-persistent \
    openvpn \
    transmission-daemon \
    transmission-qt \
    virtualbox-guest-utils \
    x11vnc \
    xserver-xorg-video-dummy \
    xubuntu-desktop

install_system() {
    printf "Installing system file: %s\n" "$1"
    sudo install -D -m "${2:-0644}" "/vagrant$1" "$1"
    sudo sed -i -e "s/\r//g" -e "s/VAGRANT_USER/$VAGRANT_USER/g" "$1"
}

install_user() {
    printf "Installing user file: %s/%s\n" ~ "$1"
    install -D -m "${2:-0600}" "/vagrant/home/$1" ~/"$1"
    sed -i -e "s/\r//g" -e "s/VAGRANT_USER/$VAGRANT_USER/g" "$1"
}

install_system /etc/iptables/rules.v4
sudo netfilter-persistent reload

install_system /etc/X11/xorg-dummy.conf
install_system /lib/systemd/system/xorg-vagrant.service
install_system /lib/systemd/system/xstartup-vagrant.service
install_system /lib/systemd/system/x11vnc-vagrant.service
sudo systemctl enable x11vnc-vagrant

install_system /usr/local/bin/start-openvpn.sh 0755

sudo systemctl disable transmission-daemon
install_system /lib/systemd/system/transmission-vagrant.service
install_user daemon/settings.json
sudo systemctl enable transmission-vagrant
sudo systemctl start transmission-vagrant

install_user .config/transmission/settings.json
install_user .config/autostart/light-locker.desktop
install_user .vnc/xstartup 0700

install_system /etc/lightdm/lightdm.conf
sudo systemctl start lightdm

sudo systemctl start x11vnc-vagrant
