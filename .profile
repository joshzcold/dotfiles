SSH_ASKPASS=ksshaskpass
export SSH_ASKPASS

BROWSER=$HOME/.nix-profile/bin/qutebrowser
export BROWSER

if [ -f "/home/joshua/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
  export XDG_DATA_DIRS=$HOME/.nix-profile/share:$HOME/.share:"${XDG_DATA_DIRS:-/usr/local/share/:/usr/share/}"
  source /home/joshua/.nix-profile/etc/profile.d/hm-session-vars.sh
fi
if [ -f "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi

# Workaround: SDL3 X11 backend calls XIQueryDevice() on a stale XInput2 device
# id and Xlib aborts the process (XI_BadDevice). Kills shadPS4 at startup.
SDL_VIDEO_X11_XINPUT2=0
export SDL_VIDEO_X11_XINPUT2
