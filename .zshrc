fpath+=$HOME/.zsh/pure
autoload -U promptinit; promptinit
setopt AUTO_NAME_DIRS
prompt pure
prompt_newline='%666v'
PROMPT=" $PROMPT"

# load custom dir colors (ignore 777 permissions for NTFS mounts)
eval "$(dircolors ~/.dircolors)"

# case insensitive file matching
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
# ZLE hooks for prompt's vi mode status
function zle-line-init zle-keymap-select {
  # Change the cursor style depending on keymap mode.
  case $KEYMAP {
    vicmd)
      printf '\e[0 q' # Box.
      ;;

    viins|main)
      printf '\e[6 q' # Vertical bar.
      ;;
    }
}
zle -N zle-line-init
zle -N zle-keymap-select

export ZSH=$HOME/.oh-my-zsh
export EDITOR=nvim
export VISUAL=nvim
export NPM_PACKAGES="${HOME}/.npm-packages"
export VAULT_ADDR="https://vault.secmet.co:8200"
export VAULT_SKIP_VERIFY=1
export MANPATH="${MANPATH-$(manpath)}:$NPM_PACKAGES/share/man"
export GOPATH=$HOME/.go/
export KUBE_EDITOR=nvim
export SUDO_ASKPASS=/usr/bin/ksshaskpass
export FZF_DEFAULT_COMMAND='rg --files'
export PYTHONWARNINGS="ignore:Unverified HTTPS request"
export PYTHONBREAKPOINT="pudb.set_trace"
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk
export TERM=xterm-kitty


# Path updates
export PATH=$PATH:/bin/
export PATH=$PATH:$HOME/.emacs.d/bin
export PATH=$PATH:$HOME/apps/node_modules/bin
export PATH=$PATH:$HOME/.gem/ruby/3.0.0/bin
export PATH=$PATH:$HOME/apps/bin
export PATH=$PATH:$HOME.cargo/bin
export PATH=$PATH:./node_modules/.bin
export PATH=$PATH:$NPM_PACKAGES/bin
export PATH=$PATH:$HOME/.config/usr-scripts
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$HOME/.local/bin

HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000000
SAVEHIST=10000000
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.

KEYTIMEOUT=1
bindkey -v

# load completions
autoload -Uz compinit
autoload -Uz bashcompinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
	compinit;
  bashcompinit;
else
	compinit -C;
  bashcompinit -C;
fi;


alias ls="ls --color=auto"
alias ps="procs"
alias sudo="sudo "
alias vim="nvim"
alias vimrc="nvim /home/joshua/.config/nvim/init.vim"
alias zshrc="nvim /home/joshua/.zshrc && source /home/joshua/.zshrc"
alias make="/usr/bin/make -j 8"
alias markdown-preview="grip -b "
alias vssh="ssh -o GlobalKnownHostsFile=/dev/null -o UserKnownHostsFile=/dev/null"
alias kdel="kubectl delete -f"
alias kcre="kubectl apply -f"
alias e="emacsclient"
alias k="kubectl"
alias kp="kubectl get pods"
alias kw="kubectl get pods -w"
alias cat="bat -p --pager=never"
alias ssh="TERM=xterm ssh"
# cd into first dir
alias cdf="cd $(ls -d */|head -n 1)" 
# bind to allow deletion after exiting normal mode vi
bindkey "^?" backward-delete-char
# Updates editor information when the keymap changes.

# lazy load kubectl completion
function kubectl() {
    if ! type __start_kubectl >/dev/null 2>&1; then
        source <(command kubectl completion zsh)
    fi

    command kubectl "$@"
}

function cdg(){ cd $(git rev-parse --show-toplevel) }

function ascii(){
  file=$(ls /usr/share/figlet/fonts | 
    fzf --preview "figlet -f {} ${1:-Moo}" )
  clear
  figlet -f $file ${*:-Moo}
}

function yu(){
  yadm pull
  yadm add -u
  yadm commit -m "update dotfiles from $(hostname)"
  yadm push
}

function searchGit(){
  cgit
  INITIAL_QUERY=""
  RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
  result=$(FZF_DEFAULT_COMMAND="$RG_PREFIX '$INITIAL_QUERY'" \
    fzf --bind "change:reload:$RG_PREFIX {q} || true" \
    --ansi --disabled --query "$INITIAL_QUERY" \
    --height=50% --layout=reverse)
  result=$(echo "$result" | cut -d ":" -f 4- |sed 's/^ *//g' )
  echo "$result"
  echo "$result" | xclip -selection c
  cd -
}

function grep-all(){
  grep --color=always -z $1 $2
}


function kold(){
  kubectl get $1 -o go-template --template '{{range .items}}{{.metadata.name}} {{.metadata.creationTimestamp}}{{"\n"}}{{end}}' | awk '$2 <= "'$(date -d '2 days ago' -Ins --utc | sed 's/+0000/Z/')'" { print $1 }'
}

function kpdel(){
  read -k1 "?Deleting $* is that okay? [y/n]?" confirm
  if [ "$confirm" = "y" ];then
    objects=( namespace pod svc ingresses.networking.k8s.io configmap pvc pv )
    for ob in "${objects[@]}"
    do
      content=$(kubectl get $ob --all-namespaces)
      for var in "$@"
      do
        if echo "$content" | grep $var >/dev/null; then
          echo "delete $ob $var"
          kubectl delete $ob $var &
        fi
      done
    done
  fi
}

function notes(){
  command cat $(readlink -f $(find ~/git/codepaste -not -path '*/\.*' -type f | \
    fzf --preview "cat {}" ))
}

function kconf(){
  found_config=$(readlink -f $(find $HOME/.kube/  -type f -name "*.yaml" | fzf))
  export KUBECONFIG=$found_config
}

function pass(){
  if bw login; then
  else
    bw list items | jq -r '.[] | [.name, .login.username, .login.password ] | @tsv' | fzf
  fi

}

function vgit(){
 found_path=$(readlink -f $(sudo find ~/git \
   -not -path '*/\.*' \
   -not -path '*/\node_modules*' \
   -not -path '*/\target*' \
   -not -path '*/\build*' \
   -not -path '*/\bin*' \
   -not -path '*/\root*' \
   -type f  -prune | fzf))
 [ ! -z $found_path ] && nvim $found_path
}

function cgit(){
  local cmd="${FZF_ALT_C_COMMAND:-"fd --search-path $HOME/git --glob '*.git' --no-ignore-vcs --hidden --prune --exec dirname {} "}"
  setopt localoptions pipefail no_aliases 2> /dev/null
  local dir="$(eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse --tiebreak=begin --bind=ctrl-z:ignore $FZF_DEFAULT_OPTS $FZF_ALT_C_OPTS" $(__fzfcmd) +m)"
  if [[ -z "$dir" ]]; then
    zle redisplay
    return 0
  fi
  zle push-line # Clear buffer. Auto-restored on next prompt.
  BUFFER="cd ${(q)dir}"

  zle accept-line
  local ret=$?
  unset dir # ensure this doesn't end up appearing in prompt expansion
  zle reset-prompt
  return $ret
}

# Best freaking function to select multiple ssh hosts
# and start a kitty term with ssh to each
function fast_ssh(){
  hosts=("${(@f)$(cat /etc/hosts | fzf -m | awk '{print $2}')}")
  pos=$(( ${#hosts[*]} ))
  last=${hosts[$pos]}

  for host in "${hosts[@]}"; do
    if [[ $host == $last ]]; then
      TERM=xterm ssh $host </dev/tty
    else
      kitty zsh -c "TERM=xterm ssh $host </dev/tty" &
    fi
  done
}

function kre(){
  kubectl delete -f $1 && kubectl apply -f $1
}

function start_nvm(){
  if [ -d "/usr/share/nvm" ]; then
    [ -z "$NVM_DIR" ] && export NVM_DIR="$HOME/.nvm"
    source /usr/share/nvm/nvm.sh --no-use
    source /usr/share/nvm/bash_completion
    source /usr/share/nvm/install-nvm-exec
  fi
}

function geb() {
    git grep -E -n $1 | while IFS=: read i j k; do git blame -L $j,$j $i | cat; done
}

function sk(){
  screenkey -p fixed -g $(slop -n -f '%g') --opacity 0.2 -s small --compr-cnt 10 &
}


#reverse menu on shift-tab
bindkey '^[[Z' reverse-menu-complete

[ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh
[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh

# . ~/.bash_completion


# user bindings
autoload edit-command-line; zle -N edit-command-line
bindkey -M vicmd 'V' edit-command-line 

setopt noflowcontrol

bindkey -s '^x' 'fast_ssh^M'
bindkey -s '^v' 'vault-list^M'
zle -N cgit
bindkey '^S' cgit

zle -N vgit
bindkey '^f' vgit

zle -N cgit
bindkey '^a' cgit

zle -N kconf
bindkey '^k' kconf
zstyle ':completion:*' menu select

# allow copy and pasting to xclip in vi-mode
function x11-clip-wrap-widgets() {
    # NB: Assume we are the first wrapper and that we only wrap native widgets
    # See zsh-autosuggestions.zsh for a more generic and more robust wrapper
    local copy_or_paste=$1
    shift

    for widget in $@; do
        # Ugh, zsh doesn't have closures
        if [[ $copy_or_paste == "copy" ]]; then
            eval "
            function _x11-clip-wrapped-$widget() {
                zle .$widget
                xclip -in -selection clipboard <<<\$CUTBUFFER
            }
            "
        else
            eval "
            function _x11-clip-wrapped-$widget() {
                CUTBUFFER=\$(xclip -out -selection clipboard)
                zle .$widget
            }
            "
        fi

        zle -N $widget _x11-clip-wrapped-$widget
    done
}


local copy_widgets=(
    vi-yank vi-yank-eol vi-delete vi-backward-kill-word vi-change-whole-line
)
local paste_widgets=(
    vi-put-{before,after}
)

# NB: can atm. only wrap native widgets
x11-clip-wrap-widgets copy $copy_widgets
x11-clip-wrap-widgets paste  $paste_widgets
# END vi-mode xclip copying and pasting
#
zmodload zsh/terminfo

function set_completion_indicator {
  echoti sc # save_cursor
  echoti cup $((LINES - 1)) $((COLUMNS - $#1)) # cursor_position
  echoti setaf $2 # set_foreground (color)
  printf %s $1
  echoti sgr 0 # exit_attribute_mode
  echoti rc # restore_cursor
  #sleep 1
}

completion_indicator_text='(completing)'
completion_indicator_color=3
function display_completion_indicator {
  compprefuncs+=(display_completion_indicator)
  set_completion_indicator $completion_indicator_text $completion_indicator_color
}

function hide_completion_indicator {
  comppostfuncs+=(hide_completion_indicator)
  # The completion code erases the indicator, so there's nothing to do.
}

compprefuncs+=(display_completion_indicator)
comppostfuncs+=(hide_completion_indicator)

function _yadm-add(){
  yadm_path="$(yadm rev-parse --show-toplevel)"
  yadm_options=$(yadm status --porcelain=v1 |
    awk -v yadm_path=${yadm_path} '{printf "%s/\"%s\"\\:\"%s\" ",  yadm_path, $2, $1 }' )
  _alternative \
    "args:custom arg:(($yadm_options))" \
    'files:filename:_files'
}

function _yadm-checkout(){ _yadm-add }

source ~/.bash_completion
