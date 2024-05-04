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
source "/home/joshua/.fzf/shell/key-bindings.zsh"
