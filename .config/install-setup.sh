#!/usr/bin/env bash

function user_prompt() {
  read -p "$1 [y/n]" -n 1 -r
  echo # (optional) move to a new line
}

user_prompt "Install packages from apt"

if [[ $REPLY =~ ^[Yy]$ ]]; then
  set -x
  sudo apt install -y \
    git \
    yadm \
    oathtool \
    xclip \
    python3-venv \
    python3-pip \
    python3-virtualenv \
    python3-virtualenvwrapper
  { set +x; } 2>/dev/null
fi

user_prompt "Setup dwm"
if [[ $REPLY =~ ^[Yy]$ ]]; then
  set -x
  cd ~/.dwm
  sudo apt install make libxft-dev libxcb-res0-dev libx11-dev libxinerama-dev libfontconfig-dev libx11-xcb-dev
  sudo make install
  sudo cp run-dwm /usr/bin/run-dwm
  sudo tee /usr/share/xsessions/dwm.desktop >/dev/null <<EOT
[Desktop Entry]
Version=1.0
Name=dwm
Exec=run-dwm
Icon=
Type=Application
EOT
  { set +x; } 2>/dev/null
fi

user_prompt "Setup packages"
if [[ $REPLY =~ ^[Yy]$ ]]; then
  set -x
  cd ~
  sudo apt install zsh curl
  if ! command -v nix-channel; then
    sh <(curl -L https://nixos.org/nix/install) --daemon
  fi

  if ! command -v nix-channel; then
    echo "You now need to exit the shell and restart this script"
    exit
  fi
  nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
  nix-channel --update
  nix-shell '<home-manager>' -A install
  { set +x; } 2>/dev/null
fi

user_prompt "Setup dictionary qutebrowser"
if [[ $REPLY =~ ^[Yy]$ ]]; then
  set -x
  /home/joshua/.nix-profile/share/qutebrowser/scripts/dictcli.py install en-US
  { set +x; } 2>/dev/null
fi

user_prompt "Clone code-paste to ~/git"
if [[ $REPLY =~ ^[Yy]$ ]]; then
  mkdir -p ~/git
  git clone git@github.com:joshzcold/codepaste.git
fi

user_prompt "Setup kmonad"
if [[ $REPLY =~ ^[Yy]$ ]]; then
  set -x
  sudo groupadd uinput
  sudo usermod -aG input $USER
  sudo usermod -aG uinput $USER
  echo 'KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"' | sudo tee /etc/udev/rules.d/90-kmonad.rules
  sudo modprobe uinput
  { set +x; } 2>/dev/null
fi

user_prompt "setup perimeter81"
if [[ $REPLY =~ ^[Yy]$ ]]; then
  set -x
  xdg-open "https://support.perimeter81.com/docs/downloading-the-agent"
  read -p "Download the deb"
  sudo apt install ~/Downloads/Perimeter81*.deb
  { set +x; } 2>/dev/null
fi

user_prompt "Install neovim plugins"
if [[ $REPLY =~ ^[Yy]$ ]]; then
  set -x
  nvim --headless "+Lazy! sync" +qa
  { set +x; } 2>/dev/null
fi

user_prompt "Change yadm remote to ssh"
if [[ $REPLY =~ ^[Yy]$ ]]; then
  set -x
  yadm remote set-url origin git@github.com:joshzcold/dotfiles.git
  { set +x; } 2>/dev/null
fi

user_prompt "Clone all securitymetrics repos"
if [[ $REPLY =~ ^[Yy]$ ]]; then
  set -x
  bash ~/.config/usr-scripts/clone_all_bb.sh
  { set +x; } 2>/dev/null
fi

user_prompt "Install nodejs dependencies for qutebrowser"
if [[ $REPLY =~ ^[Yy]$ ]]; then
  # user specific packages
  cd ~/.config/qutebrowser/userscripts
  npm install qutejs
fi

user_prompt "Install bob neovim"
if [[ $REPLY =~ ^[Yy]$ ]]; then
  cd /opt
  sudo wget https://github.com/MordechaiHadad/bob/releases/download/v3.0.1/bob-linux-x86_64.zip
  sudo unzip bob-linux-x86_64.zip
fi

user_prompt "Symlink apps into /usr/local/bin"
if [[ $REPLY =~ ^[Yy]$ ]]; then
  cd /usr/local/bin
  sudo ln -s "$(command -v kmonad)"
  sudo ln -s /home/joshua/.local/share/bob/nvim-bin/nvim
  sudo ln -s /opt/bob-linux-x86_64/bob
fi

user_prompt "Symlink ssh key from codepaste"
if [[ $REPLY =~ ^[Yy]$ ]]; then
  cd ~/.ssh
  rm id_rsa*
  ln -s "$HOME/git/codepaste/id_rsa"
  ln -s "$HOME/git/codepaste/id_rsa.pub"
fi
