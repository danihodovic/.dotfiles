export FZF_CTRL_R_OPTS='--exact'

if which fd &> /dev/null; then
  export FZF_CTRL_T_COMMAND=fd
fi


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

bindkey -M vicmd '\-' fzf-file-widget
bindkey -M vicmd '^r'   fzf-history-widget
bindkey -M viins '^r'   fzf-history-widget
bindkey -M vicmd '^s'   fzf-ssh
bindkey -M viins '^s'   fzf-ssh
