# Setup fzf
# ---------
if [[ ! "$PATH" == */home/joshua/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/joshua/.fzf/bin"
fi

# Auto-completion
# ---------------
# source "/home/joshua/.fzf/shell/completion.zsh"

# Key bindings
# ------------
if [ -f "$HOME/.fzf/shell/key-bindings.zsh" ];then
  source "$HOME/.fzf/shell/key-bindings.zsh"
fi
