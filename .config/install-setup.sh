#!/usr/bin/env bash

function user_prompt(){
  read -p "$1 [y/n]" -n 1 -r
  echo    # (optional) move to a new line
}

user_prompt "Install packages from apt"

if [[ $REPLY =~ ^[Yy]$ ]]
then
  set -x
  sudo apt install git yadm oathtool xclip
  { set +x; } 2> /dev/null 
fi

user_prompt "use yadm and get dotfiles"
if [[ $REPLY =~ ^[Yy]$ ]]
then
  set -x
  yadm clone https://github.com/joshzcold/dotfiles.git
  yadm checkout .
  { set +x; } 2> /dev/null 
fi

user_prompt "Setup dwm"
if [[ $REPLY =~ ^[Yy]$ ]]
then
  set -x
  cd ~/.dwm
  sudo apt install make libxft-dev libxcb-res0-dev libx11-dev libxinerama-dev libfontconfig-dev libx11-xcb-dev
  sudo make install
  sudo cp run-dwm /usr/bin/run-dwm
  sudo tee /usr/share/xsessions/dwm.desktop > /dev/null <<EOT
[Desktop Entry]
Version=1.0
Name=dwm
Exec=run-dwm
Icon=
Type=Application
EOT
  { set +x; } 2> /dev/null 
fi

user_prompt "Setup packages"
if [[ $REPLY =~ ^[Yy]$ ]]
then
  set -x
  cd ~
  sudo apt install zsh curl
  sh <(curl -L https://nixos.org/nix/install) --daemon
  nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
  nix-channel --update
  nix-shell '<home-manager>' -A install
  { set +x; } 2> /dev/null 
fi

user_prompt "Setup dictionary qutebrowser"
if [[ $REPLY =~ ^[Yy]$ ]]
then
  set -x
  /home/joshua/.nix-profile/share/qutebrowser/scripts/dictcli.py install en-US
  { set +x; } 2> /dev/null 
fi

user_prompt "Setup ssh keys go to github.com and copy ssh keys to ~/.ssh"
if [[ $REPLY =~ ^[Yy]$ ]]
then
  set -x
  read -p "MANUAL STEP"
  { set +x; } 2> /dev/null 
fi

user_prompt "Clone code-paste to ~/git"
if [[ $REPLY =~ ^[Yy]$ ]]
then
  mkdir -p ~/git
  git clone git@github.com:joshzcold/codepaste.git
fi

user_prompt "Setup kmonad"
if [[ $REPLY =~ ^[Yy]$ ]]
then
  set -x
  sudo groupadd uinput
  sudo usermod -aG input $USER
  sudo usermod -aG uinput $USER
  echo 'KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"' | sudo tee /etc/udev/rules.d/90-kmonad.rules
  sudo modprobe uinput
  sudo ln -s /home/joshua/.nix-profile/bin/kmonad /usr/bin/kmonad
  { set +x; } 2> /dev/null 
fi

user_prompt "setup perimeter81"
if [[ $REPLY =~ ^[Yy]$ ]]
then
  set -x
  yay --save --editmenu -S perimeter81
  user_prompt "Add --no-sandbox to perimeter81.desktop Exec"
  read -p "MANUAL STEP"
  sudo nvim /usr/share/applications/perimeter81.desktop
  { set +x; } 2> /dev/null 
fi

user_prompt "Install neovim plugins"
if [[ $REPLY =~ ^[Yy]$ ]]
then
  set -x
  nvim --headless "+Lazy! sync" +qa
  { set +x; } 2> /dev/null 
fi

user_prompt "Change yadm remote to ssh"
if [[ $REPLY =~ ^[Yy]$ ]]
then
  set -x
  yadm remote set-url origin git@github.com:joshzcold/dotfiles.git
  { set +x; } 2> /dev/null 
fi

user_prompt "Clone all securitymetrics repos"
if [[ $REPLY =~ ^[Yy]$ ]]
then
  set -x
  bash ~/.config/usr-scripts/clone_all_bb.sh
  { set +x; } 2> /dev/null 
fi

user_prompt "Install nodejs dependencies"
if [[ $REPLY =~ ^[Yy]$ ]]
then
  npm config set prefix "${HOME}/.npm-packages"
  # user specific packages
  npm install -g qutejs
fi

user_prompt "Setup printing"
if [[ $REPLY =~ ^[Yy]$ ]]
then
  sudo pacman -S cups avahi nss-mdns
  echo "Put this in your /etc/nsswitch.conf"
  echo "hosts: mymachines mdns_minimal [NOTFOUND=return] resolve [!UNAVAIL=return] files myhostname dns"
  user_prompt ""
  sudo systemctl enable --now cups avahi-daemon
fi

