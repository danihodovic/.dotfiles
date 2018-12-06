# Default prompt
export PROMPT='%F{81}%* %~ %m %# %f'
export SHELL=/bin/zsh
# Paths
# ------------
# Export paths before sourcing anything
export PATH=${HOME}/.local/bin:$PATH
export PATH=$PATH:${HOME}/.dotfiles/scripts
export PATH=${PATH}:${HOME}/.cargo/bin/
export PATH=$PATH:${HOME}/.dasht/bin
# execute local scripts without prependeing ./
export PATH=$PATH:.
# execute node files without prefixing node_modules/.bin
export PATH=$PATH:node_modules/.bin
# Virtualenv
export WORKON_HOME=${HOME}/.virtualenvs
export NVIM_DIR=${HOME}/.config/nvim
# Use n instead of nvm as it's significantly faster to start zsh with it
export N_PREFIX=${HOME}/.n
export PATH=$PATH:$N_PREFIX/bin
export PYTHONSTARTUP=~/.pythonrc
export PYTHONPATH=$PYTHONPATH:~/.dotfiles/
[ -f ~/.aws_profile ] && export AWS_PROFILE=$(cat ~/.aws_profile)
# Exclude ~/.kube/http-cache which does not contain kubeconfigs
export KUBECONFIG=$([ -d ~/.kube ] && find ~/.kube -maxdepth 1 -type f | tr '\n' ':')
export EDITOR=nvim

function find () {
  echo Use fd
}
function curl () {
  echo 'Use httpie (cmd http)'
}

# Ease of use
export dotfiles=${HOME}/.dotfiles
export plugged=${NVIM_DIR}/plugged
export vimrc=${HOME}/.dotfiles/vimrc
export zshrc=${HOME}/.dotfiles/zshrc

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
  ${HOME}/.fzf.zsh
  ${HOME}/.gvm/scripts/gvm
  ${HOME}/.rvm/scripts/rvm
  ${HOME}/.kubectl_completion
  ${HOME}/.kops_completion
  ${HOME}/.travis/travis.sh
  ${HOME}/.awless_zsh
  # Own helpers
  ${HOME}/.dotfiles/fzf-helpers.zsh
  ${HOME}/.dotfiles/docker.zsh
  ${HOME}/.dotfiles/git.zsh
  ${HOME}/.dotfiles/kubectl.zsh
  ${HOME}/.dotfiles/gcloud.zsh
  ${HOME}/.zshrc_local
)

for script in $scripts_to_source; do
  if [ -f $script ]; then
    source $script
  fi
done

if [ -d ~/.cache/antibody/ ]; then
  for f in ~/.cache/antibody/*/*.zsh; do
    source $f
  done
fi

# Reloads custom zsh completions quickly by changing the default dump path.
# I have no clue why this works...
compinit -d ~/.zcompdump_custom

# Source this after gvm, as gvm sets a custom $GOPATH...
export GOPATH=$HOME/repos/go_pkg
export PATH=$PATH:$GOPATH/bin

# Bindings
# ------------
# Find all options:                 zle -la
# To find out how a key is mapped:  bindkey <key>
# http://www.csse.uwa.edu.au/programming/linux/zsh-doc/zsh_19.html
#
# How to make custom widgets:
# http://sgeb.io/articles/zsh-zle-closer-look-custom-widgets/
# http://dougblack.io/words/zsh-vi-mode.html
# Also for visual vi-mode see: http://stackoverflow.com/a/13881077/2966951
#
# Modes: viins, vicmd

# Set vi-mode
bindkey -v

# By default, there is a 0.4 second delay after you hit the <ESC>
# key and when the mode change is registered. This results in a
# very jarring and frustrating transition between modes. Let's reduce
# this delay to 0.1 seconds.
export KEYTIMEOUT=1

# Move to the end of the line and exclude whitespace
end-of-line-no-whitespace() {
    zle vi-end-of-line
    zle vi-backward-word-end
}
zle -N end-of-line-no-whitespace

function noop {}
zle -N noop

# Paste from clipboard
vi-append-x-selection-before () {
  RBUFFER="$(xclip -o)$RBUFFER"
}
vi-append-x-selection-after () {
  CURSOR=$((CURSOR+1))
  RBUFFER="$(xclip -o)$RBUFFER"
}
zle -N vi-append-x-selection-before
zle -N vi-append-x-selection-after

tmux-copy-mode() {
  if [ -n "$TMUX" ]; then
    tmux copy-mode
  fi
}
zle -N tmux-copy-mode

# Key bindings. Wanna find weird keycodes? use cat
# Fix backspace delete in vi-mode
# http://www.zsh.org/mla/users/2009/msg00812.html
bindkey "^?" backward-delete-char
# Movement bindings
bindkey -M vicmd q vi-backward-word
bindkey -M vicmd 0 noop
bindkey -M vicmd Q vi-beginning-of-line
bindkey -M vicmd $ noop
bindkey -M vicmd W end-of-line-no-whitespace

bindkey -M vicmd P vi-append-x-selection-before
bindkey -M vicmd p vi-append-x-selection-after

bindkey -M vicmd v tmux-copy-mode

function tmux-search {
  tmux copy-mode && tmux send-keys '?' && tmux send-keys \
    BSpace BSpace BSpace BSpace BSpace BSpace BSpace BSpace BSpace BSpace BSpace BSpace
}
zle -N tmux-search

bindkey -M vicmd '/' tmux-search

# Reverse scrolling shift+tab
bindkey -M menuselect '^[[Z' reverse-menu-complete
# Aliases
# ------------
# Allows 256 colors as background in terminal, used for Vi
alias t=task
alias sed='sed -E'
alias cat='bat --style=plain'
alias tmux="tmux -2"
alias https="http --default-scheme https"
# Todo: Write a function instead
alias cd.="cd .."
alias cd..="cd ../.."
alias cd...="cd ../../.."
alias cd....='cd ../../../..'
alias tempdir='tempdir=$(mktemp -d) && cd $tempdir'
alias cp='cp -v '
alias mv='mv -v '
alias h="history"
alias cd-="cd -"
alias ls='ls --color=auto --classify -lrt --block-size=MB'
alias setxkbmapcaps="setxkbmap -option caps:swapescape68"
alias o='xdg-open'
alias v=nvim
alias k='kubectl'
alias psag='ps aux | ag '
alias ctl='sudo systemctl '
alias s3='aws s3'
alias xc='xclip -selection clipboard'

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

# cd && ls
function chpwd {
  emulate -L zsh
  \ls --color=auto --classify -lrt --block-size=MB
}

function pk {
  local processes=$(ps -eo "%p %C %c %U" | tail -n +2 | sort -k2 -n --reverse)
  local chosen_pids=$(echo $processes | fzf --multi | awk '{print $1}')
  if [ -n "$chosen_pids" ]; then
    echo $chosen_pids | xargs kill
  fi
}

function awsprofile {
  profile=$(grep --text -E '\[.+\]' ~/.aws/credentials | tr -d '[]' | fzf)
  echo $profile > ~/.aws_profile
  export AWS_PROFILE=$profile
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
  ssh "$remote_server" "rm -rf $remote_dir"

  rsync -avz --delete --cvs-exclude "$local_dir/" "$remote"

  while inotifywait \
    -e modify -e move -e create -e delete \
    --exclude '.*(\.git|\.terraform|node_modules)' \
    -r "$local_dir"; do

    notify-send "Syncing $local_dir..." -i network-transmit-receive
    rsync -avz --delete --cvs-exclude "$local_dir/" "$remote"
    pkill xfce4-notifyd
  done
}
compdef sync=scp
