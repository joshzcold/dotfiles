#!/usr/bin/env bash
set -x

function user_prompt(){
  read -p "$1 [y/n]" -n 1 -r
  echo    # (optional) move to a new line
}

user_prompt "Install git"

if [[ $REPLY =~ ^[Yy]$ ]]
then
  sudo pacman -S --needed git base-devel yadm
fi

user_prompt "use yadm and get dotfiles"
if [[ $REPLY =~ ^[Yy]$ ]]
then
  yadm clone https://github.com/joshzcold/dotfiles.git
  yadm checkout .
fi

user_prompt "Setup dwm"
if [[ $REPLY =~ ^[Yy]$ ]]
then
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
fi

user_prompt "Install yay"
if [[ $REPLY =~ ^[Yy]$ ]]
then
  cd /tmp
  git clone https://aur.archlinux.org/yay-bin.git
  cd yay-bin
  makepkg -si
fi

user_prompt "Install all applications"
if [[ $REPLY =~ ^[Yy]$ ]]
then
  cd ~
  yay -S --needed - < ~/.config/install-apps
fi

user_prompt "Setup dictionary qutebrowser"
if [[ $REPLY =~ ^[Yy]$ ]]
then
  /usr/share/qutebrowser/scripts/dictcli.py install en-US
fi

user_prompt "Setup ssh keys go to github.com and copy ssh keys to ~/.ssh"
if [[ $REPLY =~ ^[Yy]$ ]]
then
  read "MANUAL STEP"
fi

user_prompt "Setup kmonad"

if [[ $REPLY =~ ^[Yy]$ ]]
then
  sudo groupadd uinput
  sudo usermod -aG input $USER
  sudo usermod -aG uinput $USER
  sudo echo 'KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"' > /etc/udev/rules.d/90-kmonad.rules
  sudo modprobe uinput
fi

user_prompt "setup perimeter81"
if [[ $REPLY =~ ^[Yy]$ ]]
then
  yay --save --editmenu -S perimeter81
  user_prompt "Add --no-sandbox to perimeter81.desktop Exec"
  read "MANUAL STEP"
  sudo nvim /usr/share/applications/perimeter81.desktop
fi

user_prompt "Install neovim plugins"
if [[ $REPLY =~ ^[Yy]$ ]]
then
  nvim -c PackerSync
fi

user_prompt "Change yadm remote to ssh"
if [[ $REPLY =~ ^[Yy]$ ]]
then
  yadm remote set-url origin git@github.com:joshzcold/dotfiles.git
fi
