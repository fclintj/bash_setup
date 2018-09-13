#!/bin/bash
sudo apt install -y chrome-gnome-shell
sudo apt-add-repository ppa:tista/adapta
sudo add-apt-repository ppa:papirus/papirus
sudo apt-get update
sudo apt install -y adapta-gtk-theme
sudo apt install -y papirus-icon-theme
sudo apt install -y qt5-style-plugins
sudo apt remove -y gnome-shell-extension-ubuntu-dock
sudo apt install -y gnome-tweak-tool


# turn off crash reports
sudo rm -r /var/crash/*
# set enabled=0 in /etc/default/apport
# Set nemo as default folder viewer
xdg-mime default nemo.desktop inode/directory application/x-gnome-saved-search


