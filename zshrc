#!/usr/bin/env zsh
#
# There is an interesting study featured in "Thinking Fast and Slow" where they had two groups in a
# pottery class. The first group would have the entirety of their grade based on the creativity of a
# single piece they submit. The second group was graded on only the total number of pounds of clay
# they threw.

# Start a tmux session for new terminals. This does not apply if we're
# inside a tmux session already or if tmux is not installed.
start-tmux-if-exist() {
  if [ -z $TMUX ]; then
    hash tmux
    if [ $? = 0 ]; then
      tmux -2
    fi
  fi
}

if [[ "$(expr substr $(uname -s) 1 5)" == "Linux" ]]; then
    echo 'Using Linux zshrc settings...'
    setxkbmap -option caps:swapescape
    start-tmux-if-exist
    keychain ${HOME}/.ssh/id_rsa -q

elif [[ "$(uname)" == "Darwin" ]]; then
    echo 'Using Mac OS zshrc settings...'
    # Use GNU coreutils instead of bsd ones
    export PATH="$(brew --prefix coreutils)/libexec/gnubin:/usr/local/bin:$PATH"

else
    echo 'Unknown OS' $(uname)
fi


if [[ "$DESKTOP_SESSION" == "cinnamon" ]]; then
  echo 'Using cinnamon settings...'
  alias lock='cinnamon-screensaver-command -l'
elif [ "$DESKTOP_SESSION" = "i3" ]; then
  echo 'Using i3...'
  alias lock=i3lock
fi

# Settings
setopt hist_ignore_all_dups
setopt append_history
setopt no_inc_append_history
setopt no_share_history
# Paths
# ------------
# Export paths before sourcing anything
export PATH=$PATH:${HOME}/.local/bin
export GOROOT=/opt/go
export GOPATH=${HOME}/repos/go_pkg
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
export PATH=$PATH:/opt/eclipse
export PATH=$PATH:${HOME}/.dasht/bin
# Required for pinentry-ncurses
export GPG_TTY=$(tty)
# Virtualenv
export WORKON_HOME=${HOME}/.virtualenvs
export EDITOR=nvim
export PYTHONSTARTUP=~/.pythonrc

# Variables shared by personal install scripts.
# Potentially replace installs with submodules for antigen
export NVIM_DIR=${HOME}/.config/nvim
export ANTIGEN_PATH=${HOME}/.antigen/antigen.zsh

# Ease of use
export dotfiles=${HOME}/.dotfiles
export plugged=${NVIM_DIR}/plugged
export vimrc=${HOME}/.dotfiles/vimrc
export zshrc=${HOME}/.dotfiles/zshrc

# Antigen
source $ANTIGEN_PATH
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle djui/alias-tips

antigen-use oh-my-zsh
antigen theme robbyrussell/oh-my-zsh themes/steeef

antigen apply
# External scripts
# ------------
# Source these before our own `bindkeys` so that we can override stuff
# ------------
autoload bashcompinit && bashcompinit
scripts=${HOME}/.scripts
scripts=(
  ${HOME}/.fzf.zsh
  $scripts/fzf/shell/key-bindings.zsh
  ${HOME}/.dotfiles/fzf-helpers.zsh
  $scripts/i3_completion.sh
  ${HOME}/.local/bin/aws_zsh_completer.sh
  $scripts/nvm/nvm.sh
)

for script in $scripts; do
  if [ -f $script ]; then
    source $script
  else
    echo "tried sourcing ${script} but it was not found"
  fi
done

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

noop () {}
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
alias h="history"
alias cd-="cd -"
alias ls='ls --color=auto --classify'
alias setxkbmapcaps="setxkbmap -option caps:swapescape"
alias open='xdg-open'
alias vi='nvim'

# Git
alias gs='git status -sb'
alias gd='git diff'
alias gl='git log --decorate'
alias glogS='git log -p -S '
alias gf='git fetch'
alias gc='fcheckout'
alias gshow='git show'
alias grebase='git rebase -i `flog`'
alias gbranch='git branch -avv'
alias gcommit='git commit -v -S'
alias gpush='git push '
alias greset='git reset '
alias gclone='git clone '
alias gadd='git add'
alias gtags='git tag --list | sort -V'
alias gtags-latest='git tag --list | sort -V | tail -n 1'
alias gci-status='hub ci-status '
goneline() {
  n=${1:-10}
  git log --pretty=oneline --decorate=short --reverse | tail -n $n
}

# Docker
alias dps='docker ps'
alias dbuild='docker build '
alias drun='docker run '
alias drunit='docker run -i -t '
alias dexec='docker exec -i -t '
alias dkill='docker kill '
alias dkillall='docker kill $(docker ps -a -q)'
alias dstop='docker stop '
alias dstopall='docker stop $(docker ps -a -q)'
alias drm='docker rm '
alias drmall='docker rm $(docker ps -a -q)'

alias dcbuild='docker-compose build'
alias dcup='docker-compose up'
alias dcrun='docker-compose run '

alias aptinstall='sudo apt-get install '
alias aptpurge='sudo apt-get purge '
alias aptupdate='sudo apt-get update'
alias aptsearch='sudo apt-cache search '
alias aptpolicy='sudo apt-cache policy '
alias aptrepository='sudo apt-add-repository  -y'

# cd && ls
function chpwd() {
    emulate -L zsh
    ls
}

man() {
  # TODO: Add fzf helper and pipe to vim
  if [ $1 = '-k' ]; then
    apropos ${@:2}
  else
    command man ${1} > /dev/null
    if [ $? = 0 ]; then
      nvim -c 'set ft=man' -c "Man ${1}" -c 'nnoremap <buffer> q :q<cr>'
    fi
  fi
}

