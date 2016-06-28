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
bindkey -M vicmd '\-'    fzf-root-widget

export FZF_CTRL_R_OPTS='--exact'
bindkey -M vicmd '^r'   fzf-history-widget
bindkey -M viins '^r'   fzf-history-widget

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
