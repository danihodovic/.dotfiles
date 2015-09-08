# Path to your oh-my-zsh installation.
export ZSH=/home/dani/.oh-my-zsh
# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="sorin"
source $ZSH/oh-my-zsh.sh
plugins=(vi-mode git web-search)

bindkey -M vicmd q vi-backward-word
##################################
# Own ease of use paths
##################################
export dotfiles=~/.dotfiles
export plugged=~/.vim/plugged
##################################

# Z directory auto completion
source $dotfiles/scripts/z.sh

#--------------------------------
# Aliases
#--------------------------------
alias sh="bash"
alias gno="gnome-open"
alias reboot="sudo reboot"
alias cd.="cd .."
alias cd..="cd ../.."
alias cd...="cd ../../.."
alias cd-="cd -"
alias ls='ls --color=auto --classify'

alias aptupgrade="sudo apt-get update && sudo apt-get -y upgrade && sudo apt-get -y dist-upgrade"
# Swaps caps with esc
alias xkbmapcaps="setxkbmap -option caps:swapescape"
# Runs dmenu
alias ddmenu="dmenu_run -fn '-*-fixed-*-*-*-*-20-*-*-*-*-*-*-*' -l 5 -i"
alias vi='nvim'
alias gvi='/opt/nvim-qt/nvim-qt'
alias example=bro
# Allows 256 colors as background in terminal, used for Vi
alias tmux="tmux -2"

#if [ $DESKTOP_SESSION == "xubuntu" ]; then
    #alias sleepnow="xfce4-session-logout -s"
#fi

##################################
# Terminal crap
##################################
# Fixes colors for lxde-terminal. Useful for vim colorschemes
export TERM="xterm-256color"
export EDITOR=gvi
export PYTHONSTARTUP=~/.pythonrc

##################################
# Custom installations
##################################
# Golang
export GOROOT=/opt/go
export GOPATH=/opt/go_pkg
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

# Eclipse
export PATH=$PATH:/opt/eclipse

##################################
# Virtualenvwrapper
##################################
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Devel
source /usr/local/bin/virtualenvwrapper.sh

##################################
# Custom functions
##################################
function chpwd() {
    emulate -L zsh
    ls
}



# nvm completion
[[ -r $NVM_DIR/bash_completion ]] && source $NVM_DIR/bash_completion

