#!/usr/bin/env bash
export dotfiles=~/.dotfiles

alias cd.="cd .."
alias cd..="cd ../.."
alias cd...="cd ../../.."
alias cd-="cd -"
alias ls='ls --color=auto --classify'
alias grep='grep -P '

export HISTCONTROL=ignoreboth:erasedups
export TERM="xterm-256color"
export EDITOR=vi

function cd () {
  if [ "$#" == 0 ]; then
    builtin cd "$HOME" && ls
  else
    builtin cd "$*" && ls
  fi
}

# Git show branch colored
PS1="\[$GREEN\]\t\[$RED\]-\[$BLUE\]\u\[$YELLOW\]\[$YELLOW\]\w\[\033[m\]\[$MAGENTA\]\$(__git_ps1)\[$WHITE\]\$ "

export PATH=/home/dani/repos/go_pkg/bin:/home/dani/.pyenv/shims:/home/dani/.pyenv/bin:/home/dani/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/home/dani/.dotfiles/scripts:/home/dani/.cargo/bin/:/home/dani/.dasht/bin:/home/dani/.poetry/bin:/home/dani/.gem/ruby/2.7.0/bin:.:node_modules/.bin:/home/dani/.n/bin:/home/dani/.krew/bin:/opt/genymobile/genymotion/:/opt/android-studio/bin/:/home/dani/Android/Sdk/tools:/home/dani/Android/Sdk/platform-tools::/home/dani/.fzf/bin:/home/dani/repos/go_pkg/bin:/home/dani/.rvm/bin:/home/dani/bin/gyb$HOME/.cargo/env
