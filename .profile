SSH_ASKPASS=ksshaskpass
export SSH_ASKPASS

BROWSER=/usr/bin/qutebrowser
export BROWSER

if [ -f "/home/joshua/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
  export XDG_DATA_DIRS=$HOME/.nix-profile/share:$HOME/.share:"${XDG_DATA_DIRS:-/usr/local/share/:/usr/share/}"
  source /home/joshua/.nix-profile/etc/profile.d/hm-session-vars.sh
fi
