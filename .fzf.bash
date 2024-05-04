# Setup fzf
# ---------
if [[ ! "$PATH" == */home/joshua/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/joshua/.fzf/bin"
fi

# Auto-completion
# ---------------
# source "/home/joshua/.fzf/shell/completion.bash"

# Key bindings
# ------------
source "/home/joshua/.fzf/shell/key-bindings.bash"
