# xfsettingsd &

export PATH="$HOME/.nix-profile/bin:$PATH"
export XDG_DATA_DIRS="$HOME/.nix-profile/share:${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"

autorandr -c default
nitrogen --restore
# emacs --daemon &
unclutter -idle 1 -jitter 2 -root &
nm-applet &
dunst &
pamac-tray &
picom &
# keynav &
blueman-applet &
volctl &
pkill -f check-on-dotfiles; "$HOME"/.config/usr-scripts/check-on-dotfiles &
# pkill -f check_bb_reviews.sh; "$HOME"/.config/usr-scripts/check_bb_reviews.sh &
pkill -f check-on-todos.sh; "$HOME"/.config/usr-scripts/check-on-todos.sh &
kdeconnectd &
sleep 1
kdeconnect-indicator &
