# Paths
# ------------
# Export paths before sourcing anything
# Fixes colors for lxde-terminal. Useful for vim colorschemes
export TERM=xterm-256color
export NVIM_DIR=~/.config/nvim
export NVM_DIR=~/.nvm
export PATH=$PATH:/opt/nvim-qt
export GOROOT=/opt/go
export GOPATH=/opt/go_pkg
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
export PATH=$PATH:/opt/eclipse
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Devel
export EDITOR=nvim
export PYTHONSTARTUP=~/.pythonrc

# Ease of use
export dotfiles=~/.dotfiles
export repos=~/repos
export plugged=$NVIM_DIR/plugged


# Antigen
source ~/.antigen/antigen.zsh

# Plugins
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle djui/alias-tips
antigen bundle peterhurford/git-it-on.zsh

# You dont need to load oh my zsh for this to work. If you load it dont call the theme like this, it
# will cause duplicate tab completion.
antigen theme robbyrussell/oh-my-zsh themes/apple

# Useful but unused
# antigen bundle b4b4r07/enhancd
# antigen bundle Vifon/deer
# antigen bundle Valiev/almostontop
# antigen bundle zsh-users/zaw
#antigen bundle olivierverdier/zsh-git-prompt

# External scripts
# ------------
# Source these before our own `bindkeys` so that we can override stuff
source $dotfiles/scripts/z.sh

if [ -f $NVM_DIR/nvm.sh ]; then
    source $NVM_DIR/nvm.sh
fi

if [ -f $NVM_DIR/bash_completion ]; then
    source $NVM_DIR/bash_completion
fi

hash virtualenvwrapper 2>/dev/null
if [ $? == 0 ]; then
    source /usr/local/bin/virtualenvwrapper.sh
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
#
# Also for visual vi-mode see http://stackoverflow.com/a/13881077/2966951
#
# Modes: viins, vicmd

# Set vi-mode
bindkey -v

# By default, there is a 0.4 second delay after you hit the <ESC>
# key and when the mode change is registered. This results in a
# very jarring and frustrating transition between modes. Let's reduce
# this delay to 0.1 seconds.
export KEYTIMEOUT=1

# Show the vi mode you're in
#function zle-line-init zle-keymap-select {
    #RPS1="${${KEYMAP/vicmd/[NORMAL]}/(main|viins)/[INSERT]}"
    #RPS2=$RPS1
    #zle reset-prompt
#}
#zle -N zle-line-init
#zle -N zle-keymap-select

# Move to the end of the line and exclude whitespace
function end-of-line-no-whitespace {
    zle vi-end-of-line
    zle vi-backward-word-end
}
zle -N end-of-line-no-whitespace

noop () {}
zle -N noop

# Fix backspace delete in vi-mode
# http://www.zsh.org/mla/users/2009/msg00812.html
bindkey "^?" backward-delete-char

# v opens editor by default because of the vi-mode plugin in oh-my-zsh
# https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/vi-mode/vi-mode.plugin.zsh#L32
bindkey -M vicmd v noop
bindkey -M vicmd q vi-backward-word
bindkey -M vicmd 0 noop
bindkey -M vicmd Q vi-beginning-of-line
bindkey -M vicmd $ noop
bindkey -M vicmd W end-of-line-no-whitespace

bindkey -M viins '^r' history-incremental-search-backward

# Aliases
# ------------
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
alias gd='git diff'
alias gl='git log'
alias ga='git add'
alias gf='git fetch'
alias gr='git rebase'
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
elif [[ "$(uname)" == "Darwin" ]]; then
    echo 'Using Mac OS zshrc settings...'
    # Use GNU coreutils instead of bsd ones
    export PATH="$(brew --prefix coreutils)/libexec/gnubin:/usr/local/bin:$PATH"
else
    echo 'Unknown OS' $(uname)
fi


