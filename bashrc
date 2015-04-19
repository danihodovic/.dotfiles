DIR=`dirname $0`

##################################

alias sh="bash"
alias gno="gnome-open"
alias poweroff="sudo poweroff -f"
alias reboot="sudo reboot"
alias cd.="cd .."
alias cd..="cd ../.."
alias cd...="cd ../../.."
alias ls='ls --color=auto --classify'
alias vi=nvim
alias gvi=pynvim
if [ $DESKTOP_SESSION == "xubuntu" ]; then
    alias sleepnow="xfce4-session-logout -s"
fi


##################################
export EDITOR=gvi
export PYTHONSTARTUP=$DIR/rcfiles/pythonrc

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

# nvi bash completion
[[ -r $NVM_DIR/bash_completion ]] && . $NVM_DIR/bash_completion

