#!/usr/bin/env bash
set -x

read -p "Install git"
sudo pacman -S --needed git base-devel yadm

read -p "use yadm and get dotfiles"
yadm clone https://github.com/joshzcold/dotfiles.git
yadm checkout .

read -p "Setup dwm"
cd ~/.dwm
sudo make install
sudo cp run-dwm /usr/bin/run-dwm
sudo cat <<EOT >> /usr/share/xsessions/dwm.desktop
[Desktop Entry]
Version=1.0
Name=dwm
Exec=run-dwm
Icon=
Type=Application
EOT

read -p "Install yay"
cd /tmp
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si

read -p "Install all applications"
cd ~
yay -S --needed - < ~/.config/install-apps

read -p "Setup dictionary qutebrowser"
/usr/share/qutebrowser/scripts/dictcli.py install en-US

read -p "Setup ssh keys go to github.com and copy ssh keys to ~/.ssh"

read -p "Setup kmonad"
sudo groupadd uinput
sudo usermod -aG input $USER
sudo usermod -aG uinput $USER
sudo echo 'KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"' > /etc/udev/rules.d/90-kmonad.rules
sudo modprobe uinput

read -p "setup perimeter81"
yay --save --editmenu -S perimeter81
read -p "Add --no-sandbox to perimeter81.desktop Exec"
sudo nvim /usr/share/applications/perimeter81.desktop

read -p "Install neovim plugins"
nvim -c PackerSync

read -p "Change yadm remote to ssh"
yadm remote set-url origin git@github.com:joshzcold/dotfiles.git
