export ZSH=~/.oh-my-zsh
ZSH_THEME="sorin"
plugins=(vi-mode web-search)

#--------------------------------
# Bindings
# See http://www.csse.uwa.edu.au/programming/linux/zsh-doc/zsh_19.html for vi options
#--------------------------------
noop() {}
zle -N noop
bindkey -M vicmd q vi-backward-word
bindkey -M vicmd Q vi-beginning-of-line
bindkey -M vicmd W vi-end-of-line
bindkey -M vicmd $ noop
bindkey -M vicmd 0 noop

#--------------------------------
# Paths
#--------------------------------
export dotfiles=~/.dotfiles
export repos=~/repos
export plugged=~/.vim/plugged
export PATH=$PATH:/opt/nvim-qt
export GOROOT=/opt/go
export GOPATH=/opt/go_pkg
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
export NVM_DIR=~/.nvm
export PATH=$PATH:/opt/eclipse
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Devel
# Fixes colors for lxde-terminal. Useful for vim colorschemes
export TERM="xterm-256color"
export EDITOR=nvim
export PYTHONSTARTUP=~/.pythonrc

#--------------------------------
# Aliases
#--------------------------------
alias gno="gnome-open"
alias reboot="sudo reboot"
alias cd.="cd .."
alias cd..="cd ../.."
alias cd...="cd ../../.."
alias h="history"
alias cd-="cd -"
alias ls='ls --color=auto --classify'
alias aptupgrade="sudo apt-get update && sudo apt-get -y upgrade && sudo apt-get -y dist-upgrade"
alias xkbmapcaps="setxkbmap -option caps:swapescape"
alias ddmenu="dmenu_run -fn '-*-fixed-*-*-*-*-20-*-*-*-*-*-*-*' -l 5 -i"
alias vi='nvim'
alias gs='git status'
alias g="grep"
alias example='bro'
# Allows 256 colors as background in terminal, used for Vi
alias tmux="tmux -2"

# cd && ls
function chpwd() {
    emulate -L zsh
    ls
}

if [[ "$(expr substr $(uname -s) 1 5)" == "Linux" ]]; then
    echo 'Using Linux zshrc settings...'
     # Let re-use ssh-agent and/or gpg-agent between logins
     # http://www.cyberciti.biz/faq/ssh-passwordless-login-with-keychain-for-scripts/
    #keychain --quiet $HOME/.ssh/id_rsa
    #source $HOME/.keychain/$HOST-sh

elif [[ "$(uname)" == "Darwin" ]]; then
    echo 'Using Mac OS zshrc settings...'
    # Use GNU coreutils instead of bsd ones
    export PATH="$(brew --prefix coreutils)/libexec/gnubin:/usr/local/bin:$PATH"
else
    echo 'Unknown OS' $(uname)
fi


source $ZSH/oh-my-zsh.sh
source $dotfiles/scripts/z.sh
source $NVM_DIR/nvm.sh
source $NVM_DIR/bash_completion
source /usr/local/bin/virtualenvwrapper.sh
