# Default prompt
export PROMPT='%F{81}%* %~ %m %# %f'
export SHELL=/bin/zsh
export LC_ALL=en_US.UTF-8
export GPG_TTY=$(tty)
# Paths
# ------------
# Export paths before sourcing anything
export PATH=${HOME}/.local/bin:$PATH
export PATH=$PATH:${HOME}/.dotfiles/scripts
export PATH=${PATH}:${HOME}/.cargo/bin/
export PATH=$PATH:${HOME}/.dasht/bin
export PATH=$PATH:${HOME}/.poetry/bin

[ -d ${HOME}/.gem/ruby ] && for dir in $(\ls ${HOME}/.gem/ruby/); do
  export PATH=$PATH:${HOME}/.gem/ruby/$dir/bin
done
# execute local scripts without prependeing ./
export PATH=$PATH:.
# execute node files without prefixing node_modules/.bin
export PATH=$PATH:node_modules/.bin
# Virtualenv
export NVIM_DIR=${HOME}/.config/nvim
# Use n instead of nvm as it's significantly faster to start zsh with it
export N_PREFIX=${HOME}/.n
export PATH=$PATH:$N_PREFIX/bin
export PYTHONSTARTUP=~/.pythonrc
export PATH="/home/dani/.pyenv/bin:$PATH"
which pyenv > /dev/null 2>&1 && eval "$(pyenv init --path)"

[ -f ~/.aws_profile ] && export AWS_PROFILE=$(cat ~/.aws_profile)
[ -f ~/.aws_region ]  && export AWS_DEFAULT_REGION=$(cat ~/.aws_region)
export EDITOR=nvim
export PYTHONBREAKPOINT=pudb.set_trace

# Kube
export KUBECTL_EXTERNAL_DIFF=kubectl-neat-diff
export PATH="${PATH}:${HOME}/.krew/bin"

# Ease of use
export dotfiles=${HOME}/.dotfiles
export plugged=${NVIM_DIR}/plugged
export vimrc=${HOME}/.dotfiles/roles/neovim/files/vimrc
export zshrc=${HOME}/.dotfiles/zshrc

# Ansible
ANSIBLE_ENABLE_TASK_DEBUGGER=True
export ANSIBLE_CACHE_PLUGIN=jsonfile
export ANSIBLE_CACHE_PLUGIN_CONNECTION=/tmp/ansible-cache
export ANSIBLE_INVENTORY_CACHE=True
export ANSIBLE_FORCE_COLOR=1

# Django
export DJANGO_SETTINGS_MODULE=config.settings.local

# Activate direnv zsh hook if direnv is installed
type direnv > /dev/null && eval "$(direnv hook zsh)"

# Settings
setopt NO_BANG_HIST
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt AUTO_CD
# http://unix.stackexchange.com/questions/273861/unlimited-history-in-zsh
# You need to set both HISTSIZE and SAVEHIST. They indicate how many lines of history to keep in
# memory and how many lines to keep in the history file, respectively.
HISTFILE=~/.zsh_history
HISTSIZE=999999999
SAVEHIST=$HISTSIZE

setopt dot_glob

# Enable reverse-menu-complete
zmodload zsh/complist
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
# Highlight selected option in tab completion menu
zstyle ':completion:*' menu select

# External scripts
# ------------
# Source these before our own `bindkeys` so that we can override stuff
# ------------
scripts_to_source=(
  # For some reason doctl overrides other completions. Source it first then
  # source the rest
  ${HOME}/.doctl_zsh
  /usr/local/bin/aws_zsh_completer.sh
  ${HOME}/.gvm/scripts/gvm
  ${HOME}/.rvm/scripts/rvm
  ${HOME}/.kubectl_completion
  ${HOME}/.kops_completion
  ${HOME}/.travis/travis.sh
  ${HOME}/.awless_zsh
  ${HOME}/repos/dht/dht-complete.zsh
  # Own helpers
  ${HOME}/.dotfiles/docker.zsh
  ${HOME}/.dotfiles/git.zsh
  ${HOME}/.dotfiles/kubectl.zsh
  ${HOME}/.dotfiles/gcloud.zsh
  ${HOME}/.zshrc_local

  ${HOME}/.fzf.zsh
  ${HOME}/.dotfiles/fzf-helpers.zsh
  ${HOME}/.dotfiles/zsh_key_bindings.zsh
  # Not sourced by antibody for whatever reason
  ${HOME}/.cache/antibody/https-COLON--SLASH--SLASH-github.com-SLASH-jonmosco-SLASH-kube-ps1/kube-ps1.sh
)

for script in $scripts_to_source; do
  if [ -f $script ]; then
    source $script
  fi
done

# Must be ran before antibody
source <(kubectl completion zsh)

if [ -d ~/.cache/antibody/ ]; then
  for f in ~/.cache/antibody/*/*.plugin.zsh; do
    source "$f"
  done
fi


# Reloads custom zsh completions quickly by changing the default dump path.
# I have no clue why this works...
compinit -d ~/.zcompdump_custom

# Source this after gvm, as gvm sets a custom $GOPATH...
export GOPATH=$HOME/repos/go_pkg
export PATH=$PATH:$GOPATH/bin


# Aliases
# ------------
alias ls='ls -haltr --color=auto'
alias tree=tre
alias t=task
alias df=duf
alias p=pyp
alias top=htop
alias diff=icdiff
alias sed='sed -E'
alias cat='bat --style=plain'
function batf() { tail -f "$1" | bat --paging=never; }
alias tmux="tmux -2"
alias https="http --default-scheme https"
alias tempdir='tempdir=$(mktemp -d) && cd $tempdir'
alias cp='cp -v '
alias mv='mv -v '
alias h="history"
alias cd-="cd -"
alias setxkbmapcaps="setxkbmap -option caps:swapescape68"
alias o='xdg-open'
alias hledger='hledger --strict'
function v() {
  if [[ -z "$1" ]]; then
    nvim $(__fsel)
  else
    nvim $@
  fi
}
alias k='kubectl'
alias psag='ps aux | rg '
alias ctl='sudo systemctl '
alias s3='aws s3'
alias c='z -I'
alias cc='z -c'
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'
alias xc='xclip -selection clipboard'
alias h1='head -n 1'
alias t1='tail -n 1'

alias aptinstall='sudo apt install'
alias aptremove='sudo apt remove'
alias aptpurge='sudo apt purge'
alias aptautoremove='sudo apt-get autoremove'
alias aptupdate='sudo apt-get update'
alias aptupgrade='sudo apt dist-upgrade'
alias aptsearch='apt-cache search'
alias aptpolicy='apt-cache policy'
alias aptshow='apt-cache show'
alias aptrepository='sudo apt-add-repository  -y'

function ssh-keygen-fingerprint { ssh-keygen -l -f $1 }
function ssh-keygen-fingerprint-md5 { ssh-keygen -E md5 -l -f $1 }

function taskwarrior-toggle {
  if [[ $(timew) = 'There is no active time tracking.' ]]; then
    last_timewarrior_task=$(timew export | jq -r '.[-1].tags[0]')
    last_task_id=$(task $last_timewarrior_task export | jq -r '.[0].id')
    task start $last_task_id
  else
    local task_id=$(task +ACTIVE -DELETED export rc.json.array=off | jq -r .id)
    task $task_id stop
  fi
}
alias t=task
alias tt=taskwarrior-toggle
alias tc='dht task done'

function tst {
  local output=$(task add $@)
  echo $output
  local task_uuid=$(echo $output | awk -F ' ' '{print $3}' | sed 's/\.//')
  task start $task_uuid
}
compdef _task tst

function _cd_ls (){
  emulate -L zsh
  ls
}
chpwd_functions+=(_cd_ls)

function pk {
  local processes=$(ps -eo "%p %C %c %U" | tail -n +2 | sort -k2 -n --reverse)
  local chosen_pids=$(echo $processes | fzf --multi | awk '{print $1}')
  if [ -n "$chosen_pids" ]; then
    echo $chosen_pids | sudo xargs kill
  fi
}

function awsprofile {
  profile=$(grep --text -E '\[.+\]' ~/.aws/credentials | tr -d '[]' | fzf)
  if [ -n "$profile" ]; then
    echo $profile > ~/.aws_profile
    export AWS_PROFILE=$profile
  fi
}

function awsregion {
  regions=(
    "us-east-2        (Ohio)"
    "us-east-1        (N. Virginia)"
    "us-west-1        (N. California)"
    "us-west-2        (Oregon)"
    "ap-south-1       (Mumbai)"
    "ap-northeast-3   (Osaka-Local)"
    "ap-northeast-2   (Seoul)"
    "ap-southeast-1   (Singapore)"
    "ap-southeast-2   (Sydney)"
    "ap-northeast-1   (Tokyo)"
    "ca-central-1     (Canada)"
    "cn-north-1       (Beijing)"
    "cn-northwest-1   (Ningxia)"
    "eu-central-1     (Frankfurt)"
    "eu-west-1        (Ireland)"
    "eu-west-2        (London)"
    "eu-west-3        (Paris)"
    "eu-north-1       (Stockholm)"
    "sa-east-1        (São Paulo)"
  )
  selected=$(printf '%s\n' "${regions[@]}" | fzf --sort | awk '{print $1}')
  if [ -n "$selected" ]; then
    echo $selected > ~/.aws_region
    export AWS_DEFAULT_REGION=$selected
  fi
}

man() {
  if [ $1 = '-k' ] && [ $# -gt 1 ]; then
    choice=$(apropos ${@:2} | fzf | awk '{print $1}')
    man $choice
  else
    command man ${1} > /dev/null
    if [ $? = 0 ]; then
      # silent! because there is an error when `set ft=man` is executed
      nvim -c 'silent! set ft=man' -c "Man ${1}" -c 'nnoremap <buffer> q :q<cr>'
    fi
  fi
}

function httpdump {
  sudo tcpdump -A -s 0 "(((ip[2:2] - ((ip[0]&0xf)<<2)) - ((tcp[12]&0xf0)>>2)) != 0) $@"
}

function sync {
  local_dir=$1

  # user@remote:dir
  remote=$2

  remote_server=$(echo "$remote" | awk -F ':' '{print $1}')
  remote_dir=$(echo "$remote" | awk -F ':' '{print $2}')

  sync_helper

  while inotifywait \
    -e modify -e move -e create -e delete \
    --exclude '.*(\.git|\.terraform|node_modules|packer_cache)' \
    -r "$local_dir"; do

    notify-send "Syncing $local_dir..." -i network-transmit-receive
    sync_helper

    pkill xfce4-notifyd
  done
}
function sync_helper {
  rsync -avz --delete --cvs-exclude \
    --filter='protect terraform.tfstate' \
    --filter='protect terraform.tfplan' \
    "$local_dir/" "$remote"
}
compdef sync=scp

function edit-file-docker {
  set -v
  container=$(docker ps -a | fzf --exact | awk '{print $1}')
  if [ -z "$container" ] && return
  working_dir=$(docker inspect $container -f '{{ .Config.WorkingDir }}')
  host_path=/tmp/${container}
  mkdir -p ${host_path}
  docker cp ${container}:${working_dir} ${host_path}
  host_files=$(fd . ${host_path}${working_dir} | fzf --exact --multi)
  if [ -z "$host_files" ] && return
  # Strip /tmp/path from the container
  # container_file=${host_file#$host_path}
  $EDITOR ${host_files}
  docker cp ${host_path} ${container}:${working_dir}
  # docker cp ${host_file} ${container}:${container_file}
}

function gitignore-gen() {
  if [ -z $1 ]; then
    echo Provide an argument.
    echo Example: gitignore-gen python
    return
  fi
  http --body https://www.gitignore.io/api/$1
}

function k8s-delete-all-namespace-resources {
  kubectl delete "$(kubectl api-resources --namespaced=true --verbs=delete -o name | tr "\n" "," | sed -e 's/,$//')" --all
}

function git-standup-last-week() {
  python <<EOF
from datetime import date, timedelta
import subprocess
import os

today = date.today()
beginning_of_last_week = today - timedelta(days=today.weekday() + 7)
end_of_last_week = beginning_of_last_week + timedelta(days=7)
cmd = f"git standup -d {beginning_of_last_week} -u {end_of_last_week} -s"
home = os.path.expanduser("~")
dirs = [
  os.path.join(home, ".dotfiles"),
  os.path.join(home, "repos"),
  os.path.join(home, ".config/nvim/plugged"),
]
for dir in dirs:
  subprocess.run(cmd, shell=True, cwd=dir)
EOF
}

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

function install_dht() {
  latest_release_url=$(curl -s https://api.github.com/repos/danihodovic/dht/releases/latest | grep "browser_download_url" | awk -F '"' '{print $4}')
  curl $latest_release_url -L -o /tmp/dht
  chmod +x /tmp/dht
  mv /tmp/dht/ /usr/local/bin
}

export GOPATH="$HOME/repos/go_pkg"; export GOROOT="$HOME/.go"; export PATH="$GOPATH/bin:$PATH"; # g-install: do NOT edit, see https://github.com/stefanmaric/g
export NODE_REPL_EXTERNAL_MODULE=$(which node-prototype-repl)
