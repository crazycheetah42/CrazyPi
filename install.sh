#!/bin/bash

# Check if Script is Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user to run this script, please run sudo ./install.sh" 2>&1
  exit 1
fi

username=${SUDO_USER:-$(whoami)}
builddir=$(pwd)
# Update packages list and update system
apt update
apt full-upgrade -y


cp -r dotconfig/* /home/$username/.config/
cp background.jpg /home/$username/Pictures/background.jpg
mv user-dirs.dirs /home/$username/.config
chown -R $username:$username /home/$username
chmod +x /home/$username/.config/bspwm/bspwmrc
chmod +x /home/$username/.config/sxhkd/sxhkdrc

# Installing Essential Programs 
apt install feh bspwm xsecurelock sxhkd alacritty rofi polybar picom thunar lxpolkit x11-xserver-utils unzip wget curl build-essential pulseaudio pavucontrol -y
# Installing Other less important Programs
apt install neofetch chromium flameshot psmisc lxappearance papirus-icon-theme fonts-noto-color-emoji lightdm -y

# Download Nordic Theme and Nordzy cursor
cd /usr/share/themes/
git clone https://github.com/EliverLara/Nordic.git
cd $builddir
git clone https://github.com/alvatip/Nordzy-cursors
cd Nordzy-cursors
./install.sh
cd $builddir
rm -rf Nordzy-cursors

# Installing and setting up fonts
cd $builddir
mkdir -p /home/$username/.fonts
apt install fonts-font-awesome -y
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
unzip FiraCode.zip -d /home/$username/.fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Meslo.zip
unzip Meslo.zip -d /home/$username/.fonts
mv dotfonts/fontawesome/otfs/*.otf /home/$username/.fonts/
chown $username:$username /home/$username/.fonts/*
fc-cache -vf
rm ./FiraCode.zip ./Meslo.zip


# Enable graphical login and change target from CLI to GUI
systemctl enable lightdm
systemctl set-default graphical.target

# Polybar configuration
cd $builddir
bash scripts/changeinterface


reboot
