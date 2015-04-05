DIR="~/.bash"
##################################

#source $DIR/git/git-completion.bash
#source $DIR/git/git-prompt.sh

##################################

alias gno="gnome-open"
alias poweroff="sudo poweroff -f"
alias reboot="sudo reboot"
alias cd.="cd .."
alias cd..="cd ../.."
alias cd...="cd ../../.."
alias ls='ls --color=auto --classify'
alias vi=vim
alias vim=nvim
if [ $DESKTOP_SESSION == "xubuntu" ]; then
    alias sleepnow="xfce4-session-logout -s"
fi

##################################

export EDITOR=gvim

export PYTHONSTARTUP=$DIR/specific-rcfiles/pythonrc
export SCALA_HOME=/opt/scala-2.11.5
export PATH=$PATH:$SCALA_HOME/bin
export NODE_PATH=/opt/node/bin
export PATH=$NODE_PATH:$PATH

export PATH=$PATH:/opt/webstorm/bin
export PATH=$PATH:/opt/idea/bin
export PATH=$PATH:/opt/pycharm/bin
export PATH=$PATH:/opt/eclipse

##################################

function cd() {
  if [ "$#" == 0 ]; then
    builtin cd "$HOME" && ls
  else
    builtin cd "$*" && ls
  fi
}

# Git show branch colored
PS1="\[$GREEN\]\t\[$RED\]-\[$BLUE\]\u\[$YELLOW\]\[$YELLOW\]\w\[\033[m\]\[$MAGENTA\]\$(__git_ps1)\[$WHITE\]\$ "
