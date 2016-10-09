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

