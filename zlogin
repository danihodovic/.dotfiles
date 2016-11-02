if [[ "$DESKTOP_SESSION" == "cinnamon" ]]; then
  echo 'Using cinnamon settings...'
  alias lock='cinnamon-screensaver-command -l'
elif [ "$DESKTOP_SESSION" = "i3" ]; then
  alias lock=i3lock
  export $(gnome-keyring-daemon -s)
fi

# Paths
# ------------
# Export paths before sourcing anything
export PATH=$PATH:${HOME}/.local/bin
export PATH=$PATH:${HOME}/.dotfiles/scripts
export GOPATH=${HOME}/repos/go_pkg
export PATH=$PATH:/opt/eclipse
export PATH=$PATH:${HOME}/.dasht/bin
# Required for pinentry-ncurses
export GPG_TTY=$(tty)
# Virtualenv
export WORKON_HOME=${HOME}/.virtualenvs
export NVIM_DIR=${HOME}/.config/nvim
export EDITOR=nvim
# Use n instead of nvm as it's significantly faster to start zsh with it
export N_PREFIX=${HOME}/.n
export PATH=$PATH:$N_PREFIX/bin
export PYTHONSTARTUP=~/.pythonrc

# Ease of use
export dotfiles=${HOME}/.dotfiles
export plugged=${NVIM_DIR}/plugged
export vimrc=${HOME}/.dotfiles/vimrc
export zlogin=${HOME}/.dotfiles/zlogin

# Antibody
source <(antibody init)
antibody bundle zsh-users/zsh-completions
antibody bundle zsh-users/zsh-syntax-highlighting
antibody bundle djui/alias-tips
antibody bundle jarmo/expand-aliases-oh-my-zsh
antibody bundle danihodovic/steeef

# Settings
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS
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
autoload bashcompinit && bashcompinit
scripts_to_source=(
  /usr/local/bin/aws_zsh_completer.sh
  ${HOME}/.fzf.zsh
  # ${HOME}/.scripts/fzf/shell/key-bindings.zsh
  ${HOME}/.scripts/i3_completion.sh
  ${HOME}/.gvm/scripts/gvm
  ${HOME}/.rvm/scripts/rvm
  # Own helpers
  ${HOME}/.dotfiles/fzf-helpers.zsh
  ${HOME}/.dotfiles/docker.zsh
  ${HOME}/.dotfiles/git.zsh
  ${HOME}/.zlogin_local
)

for script in $scripts_to_source; do
  if [ -f $script ]; then
    source $script
  else
    echo "tried sourcing ${script} but it was not found"
  fi
done

# Lazy load kubectl completion since it's fairly slow
if hash kubectl 2> /dev/null; then
  original_kubectl=$(which kubectl)
  kubectl() {
    source <($original_kubectl completion zsh)
    unfunction kubectl
    kubectl=$original_kubectl
    $original_kubectl $@
  }
fi
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
alias tmux="tmux -2"
# Todo: Write a function instead
alias cd.="cd .."
alias cd..="cd ../.."
alias cd...="cd ../../.."
alias cd....='cd ../../../..'
alias ll='ls -lart'
alias cp='cp -v '
alias mv='mv -v '
alias h="history"
alias cd-="cd -"
alias ls='ls --color=auto --classify'
alias setxkbmapcaps="setxkbmap -option caps:swapescape68"
alias o='xdg-open'
alias vi='nvim'
function gvi { nohup nvim-qt $@ >/dev/null 2>&1 &}
alias psag='ps aux | ag '
alias ctl='sudo systemctl '

alias aptinstall='sudo apt-get install '
alias aptpurge='sudo apt-get purge '
alias aptupdate='sudo apt-get update'
alias aptupgrade='sudo apt-get dist-upgrade '
alias aptsearch='apt-cache search '
alias aptpolicy='apt-cache policy '
alias aptshow='apt-cache show '
alias aptrepository='sudo apt-add-repository  -y'

function ssh-keygen-fingerprint { ssh-keygen -l -f $1 }
function ssh-keygen-fingerprint-md5 { ssh-keygen -E md5 -l -f $1 }
function ssh-sync {
  if [ $# != '3' ]; then
    echo 'Usage:\n\t ssh-sync <source-dir> <host>@<ip> <target-dir>'
    return 1
  fi
  print -z lsyncd -log all -nodaemon -rsyncssh $@
}

# cd && ls
function chpwd {
    emulate -L zsh
    ls
}

function pk {
  local processes=$(ps -eo "%c %p %C %U" | tail -n +2 | sort -k3 -n --reverse)
  local chosen_pids=$(echo $processes | fzf --multi | awk '{print $2}')
  if [ -n "$chosen_pids" ]; then
    echo $chosen_pids | xargs kill
  fi
}

function pgcli-docker {
  local postgres_container_names=$(docker ps | awk '{print $NF}' | ag postgres)
  local lines=$(echo $postgres_container_names | wc -l)
  if [ "$lines" -eq 0 ]; then
    echo "No container with a name containing 'postgres' running"
    return 1
  fi
  if [ "$lines" -gt 1 ]; then
    echo "More than one postgres container running: \n$postgres_container_names"
    return 1
  fi

  docker run -it --rm --network container:$postgres_container_names danihodovic/pgcli -h postgres -U postgres
}

function youtube-download {
  if [ "$1" = '' ]; then
    echo 'Usage:\n\t youtube-download <url|id>'
    return 1
  fi
  drun -v $(pwd):/home/user/mps/ andrey01/mps-youtube daurl $1
}

function webm-to-m4a {
  if [ $# != '1' ]; then
     echo "Usage:\n\t $0 <file.webm>"
    return 1
  fi
  base="$(basename $1 .webm)"
  ffmpeg -i "$1" -strict -2 "$base.m4a"
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

