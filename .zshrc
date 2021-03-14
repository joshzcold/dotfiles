# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export PYTHONBREAKPOINT="pudb.set_trace"
export ZSH=$HOME/.oh-my-zsh
export PATH=$HOME/.emacs.d/bin:$HOME/apps/node_modules/bin/:$PATH

ZSH_THEME="powerlevel10k/powerlevel10k"
KEYTIMEOUT=1

plugins=(
  git
  colored-man-pages
  vi-mode
)

source $ZSH/oh-my-zsh.sh

alias vim="nvim"
alias vimrc="nvim /home/joshua/.config/nvim/init.vim"
alias zshrc="nvim /home/joshua/.zshrc && source /home/joshua/.zshrc"
alias markdown-preview="grip -b "
alias vssh="ssh -o GlobalKnownHostsFile=/dev/null -o UserKnownHostsFile=/dev/null"
alias kdel="kubectl delete -f"
alias kcre="kubectl apply -f"
alias k="kubectl"
alias mde="kitty --class=markdown nvim"
alias kp="kubectl get pods"
alias kw="watch -n 1 kubectl get pods"
alias cat="bat -p"
alias gl="git log --stats"
alias kssh="kitty +kitten ssh"
alias cdf="cd $(ls -d */|head -n 1)" # cd into first dir
export KUBE_EDITOR=nvim
export KUBECONFIG="/home/joshua/.kube/aa.yaml"
export SUDO_ASKPASS=/usr/bin/ksshaskpass
export FZF_DEFAULT_COMMAND='rg --files'
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

function cdg(){ cd $(git rev-parse --show-toplevel) }

function todo(){
  last_monday=$(date -dlast-monday +"%m_%d_%Y")
  todo_file="/home/joshua/git/org/todo/todo-$last_monday.md"
  [ ! -f "$todo_file" ] && echo "# todo $last_monday" > $todo_file
  nvim $todo_file
}

function searchGit(){
  cgit
  INITIAL_QUERY=""
  RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
  FZF_DEFAULT_COMMAND="$RG_PREFIX '$INITIAL_QUERY'" \
    fzf --bind "change:reload:$RG_PREFIX {q} || true" \
    --ansi --disabled --query "$INITIAL_QUERY" \
    --height=50% --layout=reverse
  cd -
}

function grep-all(){
  grep --color=always -z $1 $2
}

function zle-keymap-select() {
  zle reset-prompt
  zle -R
}

function kpdel(){
  kubectl delete pod $1 &
  kubectl delete svc $1 &
  kubectl delete configmap $1 &
}

function kclean(){
  # assuming all temporary k8s pods have yamls in /tmp
  find /tmp/ -name "*.yaml" | parallel kubectl delete -f
  find /tmp/ -name "*.yaml" | rm
}

function notes(){
  command cat $(readlink -f $(find ~/codepaste -not -path '*/\.*' -type f | fzf))
}

function kconf(){
  found_config=$(readlink -f $(find /home/joshua/.kube/  -type f -name "*.yaml" | fzf))
  export KUBECONFIG=$found_config
}

function pass(){
  lpass show $(lpass ls | fzf | sed 's/[^0-9]*//g')
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
  local git_list=$(dirname $(find ~/git -maxdepth 3 -name ".git"  -prune ))
  local fzf_list=""
  while IFS= read -r git_dir; do
    branch=$(cd "$git_dir"; git  branch | grep '^\*' | cut -d' ' -f2) 

    fzf_list+="$git_dir # $branch\n"   
  done <<< "$git_list"
  cd_dir=$(echo "$fzf_list" | column -t -s' ' | fzf)
  cd_dir2=$(echo "$cd_dir" | cut -d" " -f1)
  cd $cd_dir2
  git status -s -b # show status after cd
}

function kre(){
  kubectl delete -f $1 && kubectl apply -f $1
}

function cy(){
  nohup npx cypress open  >/dev/null 2>&1  &
  nvim cypress.json
}

function cypress(){
  nohup npx cypress open  >/dev/null 2>&1  &
  nvim cypress.json
}

function sshaa-unit(){
  kitty sshpass -p novell ssh root@aa_unit_1 &
  nohup kitty sshpass -p novell ssh root@aa_unit_2 >/dev/null 2>&1 &
  nohup kitty sshpass -p novell ssh root@aa_unit_3 >/dev/null 2>&1 &
  nohup kitty sshpass -p novell ssh root@aa_unit_4 >/dev/null 2>&1 &
}

function sshdops-workers(){
  kitty sshpass -p Control123 ssh dops@dops-worker4 &
  nohup kitty sshpass -p Control123 ssh dops@dops-worker0 >/dev/null 2>&1 &
  nohup kitty sshpass -p Control123 ssh dops@dops-worker1 >/dev/null 2>&1 &
  nohup kitty sshpass -p Control123 ssh dops@dops-worker2 >/dev/null 2>&1 &
  nohup kitty sshpass -p Control123 ssh dops@dops-worker3 >/dev/null 2>&1 &
}

zle -N cgit
bindkey '^s' cgit

zle -N vgit
bindkey '^f' vgit

zle -N searchGit
bindkey '^a' searchGit

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
