export FZF_CTRL_R_OPTS='--exact'

if which fd &> /dev/null; then
  export FZF_CTRL_T_COMMAND="fd . ~"
fi

# Custom fzf file widget.
# The differences are:
# 1) We add a space between LBUFFER and the selection we've made by pushing the
#    cursor one step forward before inserting our selection
# 2) After the insert we end up in viins mode instead of vicmd
fzf-file-widget() {
  CURSOR=$(($CURSOR + 1))
  LBUFFER="${LBUFFER}$(__fsel)"
  local ret=$?
  zle -K viins
  zle redisplay
  typeset -f zle-line-init >/dev/null && zle zle-line-init
  return $ret
}

stty stop undef
function fzf-ssh {
  all_matches=$(grep -P -r "Host\s+\w+" ~/.ssh/ | grep -v '\*')
  only_host_parts=$(echo "$all_matches" | awk '{print $NF}')
  selection=$(echo "$only_host_parts" | fzf)
  echo $selection

  if [ ! -z $selection ]; then
    BUFFER="ssh $selection"
    zle accept-line
  fi
  zle reset-prompt
}
zle     -N     fzf-ssh

function fzf-docker-logs {
  matches=$(docker ps --format 'table {{ .Names }}\t{{ .Image }}')
  selection=$(echo $matches | fzf --header-lines=1 | awk '{print $1}')
  if [ ! -z $selection ]; then
    args="${@:-"--tail 100 -f"}"
    BUFFER="docker logs $args $selection"
    zle accept-line
  fi
}
zle -N fzf-docker-logs

function fzf-docker-exec {
  matches=$(docker ps --format 'table {{ .Names }}\t{{ .Image }}')
  selection=$(echo $matches | fzf --header-lines=1 | awk '{print $1}')
  if [ ! -z $selection ]; then
    cmd="${@:-"sh -c 'bash || sh'"}"
    BUFFER="docker exec -it $selection $cmd"
    zle accept-line
  fi
}
zle -N fzf-docker-exec

fcommit() {
  local commits=$(git log --color=always --pretty=oneline --abbrev-commit --reverse) &&
  local commit=$(echo "$commits" | fzf --tac +s -m -e --ansi --reverse) &&
  echo -n $(echo "$commit" | sed "s/ .*//")
}

bindkey -M vicmd '\-'   fzf-file-widget

bindkey -M vicmd '^r'   fzf-history-widget
bindkey -M viins '^r'   fzf-history-widget

bindkey -M vicmd '^s'   fzf-ssh
bindkey -M viins '^s'   fzf-ssh

bindkey -M vicmd '^l'   fzf-docker-logs
bindkey -M viins '^l'   fzf-docker-logs

bindkey -M vicmd '^x'   fzf-docker-exec
bindkey -M viins '^x'   fzf-docker-exec
