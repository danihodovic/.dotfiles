set INC_APPEND_HISTORY
# Paths
# ------------
# Export paths before sourcing anything
# Fixes colors for lxde-terminal. Useful for vim colorschemes
export TERM=xterm-256color
export GOROOT=/opt/go
export GOPATH=/opt/go_pkg
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
export PATH=$PATH:/opt/eclipse
# Virtualenv
export WORKON_HOME=${HOME}/.virtualenvs
# Virtualenv
export PROJECT_HOME=${HOME}/Devel
export EDITOR=nvim
export PYTHONSTARTUP=~/.pythonrc

# Variables shared by personal install scripts.
# Potentially replace installs with submodules for antigen
export NVIM_DIR=${HOME}/.config/nvim
export ANTIGEN_PATH=${HOME}/.antigen/antigen.zsh

# Ease of use
export dotfiles=${HOME}/.dotfiles
export priv=${HOME}/.priv
export plugged=${NVIM_DIR}/plugged

# Wrk
export NODE_PROJECTS_DIR=${HOME}/repos/lab/repos

# Antigen
source $ANTIGEN_PATH
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle djui/alias-tips

antigen-use oh-my-zsh
antigen theme robbyrussell/oh-my-zsh themes/agnoster

antigen apply

# External scripts
# ------------
# Source these before our own `bindkeys` so that we can override stuff
scripts=(
  ${HOME}/.fzf.zsh
  ${HOME}/.nvm/nvm.sh
  /usr/local/bin/aws_zsh_completer.sh
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
vi-append-x-selection () {
  RBUFFER="$(xclip -o)$RBUFFER"
}
zle -N vi-append-x-selection
bindkey -M vicmd p vi-append-x-selection

tmux-copy-mode() {
  if [ -n "$TMUX" ]; then
    tmux copy-mode
  fi
}
zle -N tmux-copy-mode
bindkey -M vicmd v tmux-copy-mode

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

# fzf

# This is the exact same as the fzf file widget except that it uses a space between
# ${LBUFFER} and $(__fsel)"
fzf-file-widget() {
  LBUFFER="${LBUFFER} $(__fsel)"
  zle redisplay
}

# Temporary fix for root finding hotkey
__fselroot() {
  local cmd="locate /"
  eval "$cmd" | $(__fzfcmd) -m | while read item; do
    printf '%q ' "$item"
  done
  echo
}

fzf-root-widget() {
  LBUFFER="${LBUFFER} $(__fselroot)"
  zle redisplay
}
zle     -N   fzf-root-widget

fzf-git-status-widget() {
  # If we dont separate the declaration and definition of the variable
  # the last ran command will be the output of `local`
  local files
  files=`git diff --name-only`
  if [ $? != "0" ]; then
    return
  fi

  local result
  echo $files | fzf -m | while read item; do
    result="${result} ${item}"
  done
  LBUFFER="${LBUFFER} ${result}"
  zle redisplay
}
zle     -N     fzf-git-status-widget
bindkey -M viins '^g' fzf-git-status-widget
bindkey -M vicmd '^g' fzf-git-status-widget


# Run fzf and paste results onto command line
# This will set ` to run fzf-root-widget in vicmd and M-` to run fzf-root-widget in viins
bindkey -M vicmd '='    fzf-file-widget
bindkey -M vicmd '+' fzf-root-widget

bindkey -M vicmd '^h'   fzf-history-widget
bindkey -M viins '^h'   fzf-history-widget

# Fzf keybindings as suggested in the wiki
# https://github.com/junegunn/fzf/wiki/examples
# fda - including hidden directories
cdd() {
  local dir
  dir=$(find ${1:-.} -type d 2> /dev/null | fzf +m) && cd "$dir"
}

# cdf - cd into the directory of the selected file
cdf() {
   local file
   local dir
   file=$(fzf +m -q "$1") && dir=$(dirname "$file") && cd "$dir"
}

fe() {
  local file
  file=$(fzf --query="$1" --select-1 --exit-0)
  [ -n "$file" ] && ${EDITOR:-vim} "$file"
}

# get git commit sha
# example usage: git rebase -i `fcs`
flog() {
  local commits commit
  commits=$(git log --color=always --pretty=oneline --abbrev-commit --reverse) &&
  commit=$(echo "$commits" | fzf --tac +s +m -e --ansi --reverse) &&
  echo -n $(echo "$commit" | sed "s/ .*//")
}

# fbr - checkout git branch (including remote branches)
fcheckout() {
  local branches branch
  branches=$(git branch --all | grep -v HEAD) &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# fshow - git commit browser
fshow() {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index --toggle-sort=\` \
      --bind "ctrl-m:execute:
                echo '{}' | grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R'"
}

# TODO: Optimize these by looking at ~/.fzf/shell
ff() {
    local dir=`find $1 | fzf`
    echo $dir
}

fl() {
    local dir=`locate $1 | fzf`
}


# Aliases
# ------------
alias cd.="cd .."
alias cd..="cd ../.."
alias cd...="cd ../../.."
alias h="history"
alias cd-="cd -"
alias ls='ls --color=auto --classify'
alias aptinstall="sudo apt-get install ${1}"
alias aptupgrade="sudo apt-get update && sudo apt-get -y upgrade && sudo apt-get -y dist-upgrade"
alias setxkbmapcaps="setxkbmap -option caps:swapescape"
alias vi='nvim'
alias gs='git status'
alias gd='git diff'
alias gl='tig'
alias gbl='tig blame'
alias ga='git add'
alias gf='git fetch'
alias gr='git rebase'
alias gb='git branch -avv'
# Allows 256 colors as background in terminal, used for Vi
alias tmux="tmux -2"

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

# Start a tmux session for new terminals. This does not apply if we're
# inside a tmux session already or if tmux is not installed.
start-tmux-if-exist() {
  if [ -z $TMUX ]; then
    hash tmux
    if [ $? = 0 ]; then
      tmux
    fi
  fi
}

if [[ "$(expr substr $(uname -s) 1 5)" == "Linux" ]]; then
    echo 'Using Linux zshrc settings...'
    setxkbmap -option caps:swapescape
    start-tmux-if-exist

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
fi

