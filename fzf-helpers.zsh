fzf_opts=(
  --multi
  --reverse
  --bind ctrl-space:toggle-preview
  --bind ctrl-j:down
  --bind ctrl-k:up
  --bind ctrl-d:half-page-down
  --bind ctrl-u:half-page-up
  --bind ctrl-s:toggle-sort
  --preview-window=right:45%
)
export FZF_DEFAULT_OPTS="${fzf_opts[*]}"
export FZF_DEFAULT_COMMAND="fd --type f --no-ignore --hidden"
export FZF_CTRL_R_OPTS='--exact'

if which fd &> /dev/null; then
  export FZF_CTRL_T_COMMAND="fd"
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
    BUFFER="docker logs -f --tail 100 $args $selection"
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

function fzf-taskwarrior {
  matches_common="rc._forcecolor:on rc.defaultwidth:120 rc.detection:off rc.verbose=no"
  matches_few="task due.before:today+14d limit=30 $matches_common"
  matches_many="task due.before:today+365d limit=100 $matches_common"
  show_recent_cmd="ctrl-w:reload(task modified:today)+clear-query"
  delete_cmd="ctrl-x:reload(task {1} delete rc.confirmation:no rc.verbose=nothing && eval $matches_few)+clear-query"
  done_cmd="ctrl-f:reload(task done {1} rc.verbose=nothing && eval $matches_few)+clear-query"
  show_more_cmd="ctrl-v:reload(eval $matches_many)"
  selection=$(eval "$matches_few" |
    fzf --bind "$delete_cmd,$done_cmd,$show_recent_cmd,$show_more_cmd" \
    --expect=ctrl-e \
    --header-lines=2 --ansi --layout=reverse --border \
    --preview 'task {1} rc._forcecolor:on' \
    --preview-window=right:40%
  )

  if [[ "$(echo $selection | sed -n 1p)" == "ctrl-e" ]]; then
    task_id="$(echo $selection | sed -n 2p | awk '{print $1}')"
    tasktools edit "$task_id" --quiet
    fzf-taskwarrior
    return
  fi

  if [ ! -z $selection ]; then
    id=$(echo $selection | awk '{print $1}' | tr -d '\n')
    tasktools start "$id" --quiet
    # Accept the line to update the prompt
    zle accept-line
  fi
}
zle -N fzf-taskwarrior

bindkey -M vicmd '\-'   fzf-file-widget

bindkey -M vicmd '^r'   fzf-history-widget
bindkey -M viins '^r'   fzf-history-widget

bindkey -M vicmd '^s'   fzf-ssh
bindkey -M viins '^s'   fzf-ssh

bindkey -M vicmd '^l'   fzf-docker-logs
bindkey -M viins '^l'   fzf-docker-logs

bindkey -M vicmd '^x'   fzf-docker-exec
bindkey -M viins '^x'   fzf-docker-exec

bindkey -M viins '^w'   fzf-taskwarrior
bindkey -M vicmd '^w'   fzf-taskwarrior

zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
