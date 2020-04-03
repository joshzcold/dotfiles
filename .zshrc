export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="robbyrussell"

plugins=(
  git
  colored-man-pages
)

source $ZSH/oh-my-zsh.sh

alias cat="bat -p"
alias vim="nvim"
alias markdown-preview="grip -b "
alias vssh="ssh -o GlobalKnownHostsFile=/dev/null -o UserKnownHostsFile=/dev/null"
alias kdel="kubectl delete -f"
alias kcre="kubectl apply -f"
export KUBECONFIG=~/.kube/devops_cluster.yaml
export SUDO_ASKPASS=/usr/bin/ksshaskpass
export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden'
export GOVC_INSECURE=1
# export GOVC_URL="https://vlabvc08.nqeng.lab/sdk"
export GOVC_URL=https://prvengvc01.nqeng.lab/sdk
export GOVC_DATACENTER=Main
# export GOVC_DATACENTER="K8S"
export GOVC_USERNAME="corpdom\jcold"
bindkey -v
# bind to allow deletion after exiting normal mode vi
bindkey "^?" backward-delete-char
# Updates editor information when the keymap changes.

function grep-all(){
  grep --color=always -z $1 $2
}
function zle-keymap-select() {
  zle reset-prompt
  zle -R
}

function notes(){
  cat $(readlink -f $(find ~/codepaste -not -path '*/\.*' -type f | fzf))
}

function pass(){
  lpass show $(lpass ls | fzf | sed 's/[^0-9]*//g')
}

function countdown(){
   date1=$((`date +%s` + $1)); 
   while [ "$date1" -ge `date +%s` ]; do 
     echo -ne "$(date -u --date @$(($date1 - `date +%s`)) +%H:%M:%S)\r";
     sleep 0.1
   done
}
function stopwatch(){
  date1=`date +%s`; 
   while true; do 
    echo -ne "$(date -u --date @$((`date +%s` - $date1)) +%H:%M:%S)\r"; 
    sleep 0.1
   done
}

zle -N zle-keymap-select
function vi_mode_prompt_info() {
  echo "${${KEYMAP/vicmd/[% NORMAL]%}/(main|viins)/[% INSERT]%}"
}

# define right prompt, regardless of whether the theme defined it
RPS1='$(vi_mode_prompt_info)'
RPS2=$RPS1
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
if [ /usr/bin/kubectl ]; then source <(kubectl completion zsh); fi
