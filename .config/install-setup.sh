#!/usr/bin/env bash
set -eou pipefail
RESET='\033[0m'
BlACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
PS4="${YELLOW}>>>${RESET} "

function user_prompt() {
    echo -e "${YELLOW}$1 ${RESET}[y/n]"
    read -n 1 -r
    echo
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

user_prompt "Setup packages and nix-channel"
if [[ $REPLY =~ ^[Yy]$ ]]; then
    set -x
    cd ~
    sudo apt install zsh curl
    if ! command -v nix-channel; then
        sh <(curl -L https://nixos.org/nix/install) --daemon --yes
    fi

    if ! command -v nix-channel; then
        echo "You now need to exit the shell and restart this script"
        exit
    fi
    nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs-unstable
    nix-channel --add https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz home-manager
    nix-channel --update
    { set +x; } 2>/dev/null
fi

user_prompt "Run nix home-manager"
if [[ $REPLY =~ ^[Yy]$ ]]; then
    nix-shell '<home-manager>' -A install
    { set +x; } 2>/dev/null
fi

user_prompt "Get nixGL"
if [[ $REPLY =~ ^[Yy]$ ]]; then
    nix-channel --add https://github.com/nix-community/nixGL/archive/main.tar.gz nixgl && nix-channel --update
    nix-env -iA nixgl.auto.nixGLDefault # or replace `nixGLDefault` with your desired wrapper
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

user_prompt "Install nodejs dependencies for qutebrowser"
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # user specific packages
    cd ~/.config/qutebrowser/userscripts
    npm install qutejs
fi

user_prompt "Install bob neovim"
if [[ $REPLY =~ ^[Yy]$ ]]; then
    cd /opt
    sudo rm -f bob-linux-x86_64.zip
    sudo wget https://github.com/MordechaiHadad/bob/releases/download/v4.1.1/bob-linux-x86_64.zip
    sudo unzip bob-linux-x86_64.zip
fi

user_prompt "Install tree-sitter cli"
if [[ $REPLY =~ ^[Yy]$ ]]; then
    cd /opt || exit 1
    sudo rm -f tree-sitter-linux-x64.gz
    sudo wget https://github.com/tree-sitter/tree-sitter/releases/download/v0.26.3/tree-sitter-linux-x64.gz
    sudo gunzip ./tree-sitter-linux-x64.gz
    sudo mkdir -p tree-sitter-cli
    sudo mv ./tree-sitter-linux-x64 ./tree-sitter-cli/tree-sitter
    sudo chmod +x tree-sitter-cli/tree-sitter
fi

user_prompt "Symlink apps into /usr/local/bin"
if [[ $REPLY =~ ^[Yy]$ ]]; then
    set -x
    cd /usr/local/bin
    sudo ln -sf "$(command -v kmonad)"
    sudo ln -sf /home/joshua/.local/share/bob/nvim-bin/nvim
    sudo ln -sf /opt/bob-linux-x86_64/bob
    sudo ln -sf /opt/tree-sitter-cli/tree-sitter
    { set +x; } 2>/dev/null
fi

user_prompt "Symlink ssh key from codepaste"
if [[ $REPLY =~ ^[Yy]$ ]]; then
    cd ~/.ssh
    rm id_rsa*
    ln -s "$HOME/git/codepaste/id_rsa"
    ln -s "$HOME/git/codepaste/id_rsa.pub"
fi
