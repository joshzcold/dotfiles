fpath+=$HOME/.zsh/pure
autoload -U promptinit; promptinit
setopt AUTO_NAME_DIRS
prompt pure
prompt_newline='%666v'
PROMPT=" $PROMPT"
# [ ! -d ~/.fzf-tab/ ] && git clone https://github.com/Aloxaf/fzf-tab ~/.fzf-tab
# source ~/.fzf-tab/fzf-tab.plugin.zsh
# zstyle ':fzf-tab:*' accept-line enter

# load custom dir colors (ignore 777 permissions for NTFS mounts)
eval "$(dircolors ~/.dircolors)"

# case insensitive file matching
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

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
export MANPATH="${MANPATH-$(manpath)}:$NPM_PACKAGES/share/man"
export MANPAGER="/usr/bin/less -r -X -is"
export GOPATH=$HOME/.go
export KUBE_EDITOR=nvim
export SUDO_ASKPASS=/usr/bin/ksshaskpass
export FZF_DEFAULT_COMMAND='rg --files'
export ANDROID_SDK_ROOT='/opt/android-sdk'
export ANDROID_HOME='/opt/android-sdk'
export CHROME_EXECUTABLE=chromium
export PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools/
export PATH=$PATH:$ANDROID_SDK_ROOT/tools/bin/
export PATH=$PATH:$ANDROID_ROOT/emulator
export PATH=$PATH:$ANDROID_SDK_ROOT/tools/

# Python
export PYTHONWARNINGS="ignore:Unverified HTTPS request"
export WORKON_HOME=~/.virtualenvs
source /usr/bin/virtualenvwrapper_lazy.sh

export PYTHONBREAKPOINT="pudb.set_trace"
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk
export TERM=xterm-kitty
export JIRA_API_TOKEN=$(cat ~/git/codepaste/JiraToken)
export JIRA_AUTH_TYPE="password"
export CR_PAT=$(cat ~/git/codepaste/GitHubContainerRegistryToken)

# let `time` command output in simple seconds
export TIMEFORMAT=%R

# Path updates
export PATH=$PATH:/bin/
export PATH=$PATH:$HOME/.emacs.d/bin
export PATH=$PATH:$HOME/apps/node_modules/bin
export PATH=$PATH:$HOME/.gem/ruby/3.0.0/bin
export PATH=$PATH:$HOME/apps/bin
export PATH=$PATH:$HOME.cargo/bin
export PATH=$PATH:./node_modules/.bin
export PATH=$PATH:$NPM_PACKAGES/bin
export PATH=$PATH:/opt/flutter/bin
export PATH=$PATH:/opt/android-sdk/tools/bin
export PATH=$PATH:$HOME/.config/usr-scripts
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/dotnet/tools

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


alias genpass="openssl rand -base64 32"
alias ls="ls --color=auto"
alias sudo="sudo "
alias vim="nvim"
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
alias ag="./ur || ansible-galaxy install -r ansible-requirements.yml -f"
alias ansible-update-hostsfile="sudo ansible-playbook  playbooks/hostsfile.yml"
alias mk="mkvirtualenv"
alias wk="workon"
alias dk="deactivate"
alias flow="./flow"
alias p81dns="sudo systemd-resolve --interface=p81 --set-dns 10.1.1.2 --set-dns 10.29.10.2 --set-dns 10.29.10.3 --set-domain secmet.co"

# cd into first dir
alias cdf="cd "$(ls -d */|head -n 1)""
# bind to allow deletion after exiting normal mode vi
bindkey "^?" backward-delete-char
# Updates editor information when the keymap changes.

function toggle_lights(){
  if [ -n "$CURRENT_KITTY_THEME" ]; then
    kitty +kitten themes --reload-in=all Github Dark
    export CURRENT_KITTY_THEME=
  else
    kitty +kitten themes --reload-in=all Github
    export CURRENT_KITTY_THEME=ON
  fi
}

# lazy load kubectl completion
function kubectl() {
    if ! type __start_kubectl >/dev/null 2>&1; then
        source <(command kubectl completion zsh)
    fi

    command kubectl "$@"
}

function pacman-update-mirrors(){
  sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
  sudo reflector --latest 20 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
}

function cdg(){ cd $(git rev-parse --show-toplevel) }

function ascii(){
  file=$(ls /usr/share/figlet/fonts |
    fzf --preview "figlet -f {} ${1:-Moo}" )
  clear
  figlet -f $file ${*:-Moo}
}

git_hard_reset(){
  answer=""
  command=( "git" "reset" "--hard" "origin/$(git rev-parse --abbrev-ref HEAD)" )

  echo -n "Executing '${command}' are you sure? [y/N]"
  vared answer
  if [ "$answer" = "y" ]; then
    git fetch origin
    "${command[@]}"
  fi
}

function yu(){
  yadm status
  yadm pull
  yadm add -u
  yadm commit -m "update dotfiles from $(hostname)"
  yadm push
}

function vault-token(){
  if timeout 5s vault login -method oidc role="admin" >/dev/null 2>&1; then
    token=$(cat ~/.vault-token)
    xdotool type "$token"
    ( qutebrowser :tab-close > /dev/null 2>&1 & )
  else
    echo "ERROR"
  fi
}

function searchGitHistory(){
  INITIAL_QUERY=""
  RG_PREFIX="git grep --column --color=always --threads 4"
  GIT_COMMITS=$(git rev-list --all | tr '\n' ' ')
  result=$(FZF_DEFAULT_COMMAND="$RG_PREFIX '$INITIAL_QUERY'" \
    fzf --bind "change:reload:$RG_PREFIX '{q}' ${GIT_COMMITS} | tr -s ' ' || true" \
    --preview 'echo {} | cut -d ":" -f 1 | xargs -I% git log -n 1 %; echo;echo; echo {} | cut -d ":" -f 4- | sed "s/^ *//g" ' \
    --preview-window up,20,border-horizontal \
    --ansi --disabled --query "$INITIAL_QUERY" )
  result=$(echo "$result" | cut -d ":" -f 4- | sed "s/^ *//g")
  echo "$result"
  echo "$result" | xclip -selection c
}

function grep-all(){
  grep --color=always -z $1 $2
}

function notes(){
  command cat $(readlink -f $(find ~/git/codepaste -not -path '*/\.*' -type f | \
    fzf --preview "cat {}" ))
}

function klog(){
  deployments=$(k get deployments.apps -o custom-columns=:metadata.name | sed '/^$/d' | fzf -m)
  kubetail "${deployments}"
}

function kconf(){
  found_config=$(readlink -f $(find $HOME/.kube/  -type f -name "*.y*ml" -o -name "config" | fzf))
  export KUBECONFIG=$found_config
}

function k_switch_namespace(){
  namespace=$(k get ns --no-headers | awk '{print $1}' | fzf)
  if [ -n "${namespace}" ]; then
    kubectl config set-context --current --namespace="${namespace}"
    zle reset-prompt
  fi
}

function pass(){
  if bw login; then
  else
    bw list items | jq -r '.[] | [.name, .login.username, .login.password ] | @tsv' | fzf
  fi

}

function git_clean_up_dangling_branches(){
  git branch --merged | grep -Pv "^(\*|\+|master)" | xargs git branch -D || true
}

function git_clean_up_non_remote_branches(){
  git branch --format "%(refname:short) %(upstream)" | \
    awk '{if (!$2) print $1;}' | \
    grep -Pv "^(\*|\+|master)" | \
    rev | cut -d '/' -f1 | rev | \
    xargs git branch -D || true
}

function vgit(){
 found_path=$(readlink -f $(find ~/git \
   -not -path '*/\.*' \
   -not -path '*/\node_modules*' \
   -not -path '*/\target*' \
   -not -path '*/\build*' \
   -not -path '*/\bin*' \
   -not -path '*/\root*' \
   -type f  -prune | fzf -m))
    [ ! -z $found_path ] && nvim $(echo "$found_path" | tr "\n" " ")
}

function cgit(){
  local cmd=${FZF_ALT_C_COMMAND:-"fd --search-path $HOME/git --glob '*.git' --no-ignore-vcs --hidden --prune --exec dirname {}"}
  setopt localoptions pipefail no_aliases 2> /dev/null
  local dir="$(eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --preview='cd {}; git symbolic-ref -q --short HEAD || git describe --tags --exact-match' --reverse --preview-window up,1,border-horizontal $FZF_DEFAULT_OPTS $FZF_ALT_C_OPTS" $(__fzfcmd) +m)"
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

function git_branch(){
  selected_line="$(git branch -r -q | fzf -0 --bind 'ctrl-b:reload(git fetch origin; git branch -r)' | awk '{print $1}')"

  if [ ! -z "$selected_line" ];then
    git checkout -q "$selected_line"
    git switch "$(echo ${selected_line//origin\/})"
    git pull
  fi
  zle push-line
  zle accept-line
  zle reset-prompt
  return 0
}
function new_jira_branch(){
  ( git fetch origin &>/dev/null & )
  selected_line="$(jira issue list --plain --columns 'KEY,STATUS,TYPE,SUMMARY,ASSIGNEE' -a "$(jira me)" -s 'In Progress' -s 'Code Review' -s 'In QA' --no-headers | fzf)"
  [ -z "$selected_line" ] && return
  key="$(echo "${selected_line}" | awk '{print $1}')"

  # Get a default value for the suffix
  default_suffix="$(echo "${selected_line}" | tr -s '\t' | awk -F '\t' '{print $4}')" # Start with the summary
  default_suffix="$(echo "${default_suffix}" | tr '[:upper:]' '[:lower:]')" # To lowercase
  default_suffix="$(echo "${default_suffix}" | tr '[:punct:]' '_' | tr ' ' '_')" # Replace special characters with underscores
  default_suffix="$(echo "${default_suffix}" | tr -s '_')" # Remove duplicate underscores
  default_suffix="$(echo "${default_suffix}" | cut -c 1-40)" # Shorten to 40 characters
  default_suffix="$(echo "${default_suffix}" | sed -e 's/_$//')" # Remove trailing underscores

  branch_summary="${default_suffix}"
  suffix_prompt="Branch suffix?: "
  echo
  echo -n "${suffix_prompt}"
  vared branch_summary
  branch="${key}_${branch_summary}"

  if git rev-parse --verify "${branch}" &>/dev/null; then
    echo "Branch ${branch} already exists"
    return 1
  fi

  git checkout --no-track -b "${branch}" origin/master
}

function prometheus_unhealthy_targets(){
  if [ "$1" = "-j" ];then
    prom_ip="$(dig +short $(echo "$2" | cut -d '/' -f3 | cut -d ':' -f1 ))"
    [ -z "$prom_ip" ] && prom_ip=$2
    curl -k -s "$2/api/v1/targets" | jq --arg status "${3:-down}"  --arg prom_ip "${prom_ip}" -r '.data.activeTargets[] | select(.health == $status) | [$prom_ip, "=>", .labels.instance, .labels.job] | @tsv'
  elif [ "$1" = "-u" ];then
    prom_ip="$(dig +short $(echo "$2" | cut -d '/' -f3 | cut -d ':' -f1 ))"
    [ -z "$prom_ip" ] && prom_ip=$2
    curl -k -s "$2/api/v1/targets" | jq --arg status "${3:-down}"  --arg prom_ip "${prom_ip}" -r '.data.activeTargets[] | select(.health == $status) | [$prom_ip, "=>", .scrapeUrl] | @tsv'
  else
    prom_ip="$(dig +short $(echo "$1" | cut -d '/' -f3 | cut -d ':' -f1 ))"
    [ -z "$prom_ip" ] && prom_ip=$1
    curl -k -s "$1/api/v1/targets" | jq --arg status "${2:-down}" --arg prom_ip "${prom_ip}" -r '.data.activeTargets[] | select(.health == $status) | [$prom_ip, "=>", .labels.instance] | @tsv'
  fi
}

function prometheus_firing_alerts(){
  curl -s "$1/api/v1/alerts" | jq -r '.data.alerts[] | select(.state == "firing") | .labels | [.hostname, .instance] | @tsv'
}


function hosts(){
  cat /etc/hosts | fzf -m
}
# Best freaking function to select multiple ssh hosts
# and start a kitty term with ssh to each
function fast_ssh(){
  hosts=("${(@f)$(cat /etc/hosts | fzf -m | awk '{print $2}')}")
  pos=$(( ${#hosts[*]} ))
  last=${hosts[$pos]}

  for host in "${hosts[@]}"; do
    # add to history
    print -s "ssh $host"
    if [[ $host == $last ]]; then
      TERM=xterm ssh $host </dev/tty
    else
      kitty --detach zsh -c "TERM=xterm ssh $host </dev/tty" &
    fi
  done
}

function fast_ssh_broadcast(){
  hosts=("${(@f)$(cat /etc/hosts | fzf -m | awk '{print $2}')}")
  pos=$(( ${#hosts[*]} ))
  last=${hosts[$pos]}

  kitty @ goto-layout grid
  for host in "${hosts[@]}"; do
    kitty @ new-window
    kitty @ send-text ssh $host
  done
  kitty @ focus-window -m id:1
  if [[ ${#hosts[@]} = 2 ]]; then
    kitty @ resize-window -m id:1 -i -50
  fi
  kitty +kitten broadcast
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
bindkey -s '^z' 'fast_ssh_broadcast^M'
bindkey -s '^j' 'new_jira_branch^M'

zle -N toggle_lights
bindkey '^t' toggle_lights

zle -N vault-token
bindkey '^v' vault-token
zle -N cgit
bindkey '^S' cgit

zle -N vgit
bindkey '^f' vgit

zle -N cgit
bindkey '^a' cgit

zle -N git_branch
bindkey '^b' git_branch

zle -N kconf
bindkey '^k' kconf

zle -N klog
bindkey '^l' klog

zle -N k_switch_namespace
bindkey '^n' k_switch_namespace
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

source ~/.bash_completion

function _yadm-add(){
  local -a yadm_options yadm_path
  yadm_path="$(yadm rev-parse --show-toplevel)"
  yadm_options=($(yadm status --porcelain=v1 |
    awk -v yadm_path=${yadm_path} '{printf "%s/%s:%s\n",  yadm_path, $2, $1}' ))

  _describe 'command' yadm_options
  _files
}

function _yadm-checkout(){ 
    _yadm-add 
}

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/bin/vault vault
