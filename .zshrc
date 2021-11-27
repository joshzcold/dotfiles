# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export PYTHONBREAKPOINT="pudb.set_trace"
export ZSH=$HOME/.oh-my-zsh
export PATH=$HOME/.emacs.d/bin:$HOME/apps/node_modules/bin/:/home/joshua/.gem/ruby/3.0.0/bin:$HOME/apps/bin:/home/joshua/.cargo/bin:./node_modules/.bin:$PATH
export EDITOR=nvim
export NPM_PACKAGES="${HOME}/.npm-packages"
export PATH="$PATH:$NPM_PACKAGES/bin"
export MANPATH="${MANPATH-$(manpath)}:$NPM_PACKAGES/share/man"
export GOPATH=$HOME/.go/
export PATH=$GOPATH/bin:$PATH
export PATH=~/.local/bin:$PATH
export KUBE_EDITOR=nvim
export SUDO_ASKPASS=/usr/bin/ksshaskpass
export FZF_DEFAULT_COMMAND='rg --files'
export PYTHONWARNINGS="ignore:Unverified HTTPS request"
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk

KEYTIMEOUT=1

plugins=(
  git
  git-auto-fetch
  colored-man-pages
  man
  vi-mode
  docker
  helm
)

# auto update oh my zsh instead of asking.
DISABLE_UPDATE_PROMPT=true 
source $ZSH/oh-my-zsh.sh

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
alias cat="bat -p"
alias ssh="TERM=xterm-color ssh"
# alias cd="cd_last_pwd"
alias cdf="cd $(ls -d */|head -n 1)" # cd into first dir
bindkey -v
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

function zle-keymap-select() {
  zle reset-prompt
  zle -R
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
  local cmd="${FZF_ALT_C_COMMAND:-"command find -L ~/git -name \"*.git\" -exec dirname {} \; -prune 2>/dev/null  "}"
  setopt localoptions pipefail no_aliases 2> /dev/null
  local dir="$(eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse --bind=ctrl-z:ignore $FZF_DEFAULT_OPTS $FZF_ALT_C_OPTS" $(__fzfcmd) +m)"
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

function kre(){
  kubectl delete -f $1 && kubectl apply -f $1
}

function geb() {
    git grep -E -n $1 | while IFS=: read i j k; do git blame -L $j,$j $i | cat; done
}

function sk(){
  screenkey -p fixed -g $(slop -n -f '%g') --opacity 0.2 -s small --compr-cnt 10 &
}

zle -N cgit
bindkey '^s' cgit

zle -N vgit
bindkey '^f' vgit

zle -N searchGit
bindkey '^a' searchGit

zle -N kconf
bindkey '^k' kconf

#reverse menu on shift-tab
bindkey '^[[Z' reverse-menu-complete

zle -N zle-keymap-select
function vi_mode_prompt_info() {
  echo "${${KEYMAP/vicmd/[% NORMAL]%}/(main|viins)/[% INSERT]%}"
}

# define right prompt, regardless of whether the theme defined it
RPS1='$(vi_mode_prompt_info)'
RPS2=$RPS1
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# zprof

. ~/.bash_completion
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
