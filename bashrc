alias sh="bash"
alias gno="gnome-open"
alias poweroff="sudo poweroff -f"
alias reboot="sudo reboot"
alias cd.="cd .."
alias cd..="cd ../.."
alias cd...="cd ../../.."
alias ls='ls --color=auto --classify'

alias aptupgrade="sudo apt-get update && sudo apt-get upgrade && sudo apt-get dist-upgrade"
alias xkbmapcaps="setxkbmap -option caps:swapescape"
alias ddmenu="dmenu_run -fn '-*-fixed-*-*-*-*-20-*-*-*-*-*-*-*' -l 5 -i"


if [ $DESKTOP_SESSION == "xubuntu" ]; then
    alias sleepnow="xfce4-session-logout -s"
fi

alias vi='nvim'
alias gvi='/opt/nvim-qt/nvim-qt'
# Allows 256 colors as background in terminal, used for Vi
alias tmux="tmux -2"

##################################
# Terminal crap
##################################
# Fixes colors for lxde-terminal
export TERM="xterm-256color"
export EDITOR=gvi
export PYTHONSTARTUP=~/.dotfiles/rcfiles/pythonrc

##################################
# Custom installations
##################################
export GOROOT=/opt/go
export PATH=$PATH:$GOROOT/bin

##################################
# Own ease of use paths
##################################
export dotfiles=~/.dotfiles
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

