# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git
  colored-man-pages
  vi-mode
)

source $ZSH/oh-my-zsh.sh

alias vim="nvim"
alias markdown-preview="grip -b "
alias vssh="ssh -o GlobalKnownHostsFile=/dev/null -o UserKnownHostsFile=/dev/null"
alias kdel="kubectl delete -f"
alias kcre="kubectl apply -f"
alias k="kubectl"
alias kp="kubectl get pods"
alias gitl="git log --stats"
alias kssh="kitty +kitten ssh"
alias cdf="cd $(ls -d */|head -n 1)" # cd into first dir
export KUBE_EDITOR=nvim
export KUBECONFIG="/home/joshua/.kube/aa.yaml"
export SUDO_ASKPASS=/usr/bin/ksshaskpass
export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden'
export GOVC_INSECURE=1
# export GOVC_URL="https://vlabvc08.nqeng.lab/sdk"
export GOVC_URL=https://vlabw1vc.nqeng.lab/sdk
export GOVC_DATACENTER=main
# export GOVC_DATACENTER="K8S"
export GOVC_USERNAME="corpdom\jcold"
export GOPATH=$HOME/git/go
export PATH=$HOME/git/go/bin:$HOME/.local/bin:$PATH
bindkey -v
# bind to allow deletion after exiting normal mode vi
bindkey "^?" backward-delete-char
# Updates editor information when the keymap changes.

function cdg(){
  cd $(git rev-parse --show-toplevel)
}
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

function kconf(){
  found_config=$(readlink -f $(find /home/joshua/.kube/  -type f -name "*.yaml" | fzf))
  export KUBECONFIG=$found_config
}

function pass(){
  lpass show $(lpass ls | fzf | sed 's/[^0-9]*//g')
}

function cgit(){
  cd $(dirname $(readlink -f $(find ~/git -maxdepth 3 -name ".git"  -prune | fzf))) 
  git status -s -b
}

function cy(){
  nohup kitty nvim >/dev/null 2>&1 &
  npx cypress open &
}

function cypress(){
  nohup kitty nvim >/dev/null 2>&1 &
  npx cypress open &
}

zle -N cgit
bindkey '^s' cgit

#reverse menu on shift-tab
bindkey '^[[Z' reverse-menu-complete

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

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
