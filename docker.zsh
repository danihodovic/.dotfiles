#!/usr/bin/env zsh
custom_ps_format='table {{.Names}}\t{{.Image}}\t{{.ID}}\t{{.Command}}\t{{.Ports}}\t{{.Mounts}}'

alias drun='docker run '
alias dstart='docker start '
alias dps="docker ps --format='$custom_ps_format'"
alias dbuild='docker build '
alias dbuildt='docker build -t '
alias dkill='docker kill '
alias dkillall='docker kill $(docker ps -q)'
alias dstop='docker stop '
alias dstoprunning='docker stop $(docker ps -q)'
alias dstopall='docker stop $(docker ps -a -q)'
alias drmall='docker rm $(docker ps -a -q)'
alias dsearch='docker search '

alias dcbuild='docker-compose build'
alias dcup='docker-compose up'
alias dcdown='docker-compose down -v --remove-orphans'
alias dcrun='docker-compose run --rm '
alias dcexec='docker-compose exec '
alias dclogs='docker-compose logs'
# fzf --header-lines=1 --tac
fcontainer() {
  echo "$(docker ps --format=$custom_ps_format | fzf --header-lines=1 --multi | \
    awk '{print $1 != "" ? $1 : $3}')"
}
fcontainerall() {
  echo "$(docker ps --format=$custom_ps_format -a | fzf --header-lines=1 | \
    awk '{print $1 != "" ? $1 : $3}')"
}
fimage() {
  echo "$(docker images | fzf --header-lines=1 | awk '{print $1}')"
}

dri() {
  choice=$(fimage)
  if [ -n "$choice" ]; then
    print -z docker run $@ "$choice"
  fi
}

drm() {
  choice=$(fcontainer)
  if [ -n "$choice" ]; then
    print -z docker rm -f $@ "$choice"
  fi
}

dsc() {
  choice=$(fcontainerall)
  if [ -n "$choice" ]; then
    print -z docker start $@ "$choice"
  fi
}
dsh() {
  choice=$(fcontainer)
  if [ -n "$choice" ]; then
    print -z docker exec -i -t "$choice" bash || sh
  fi
}
di() {
  matches=$(docker ps --format 'table {{ .Names }}\t{{ .Image }}')
  selection=$(echo $matches | fzf --header-lines=1 | awk '{print $1}')
  if [ ! -z $selection ]; then
    cmd="docker inspect $selection | bat"
    print -s $cmd
    eval $cmd
  fi
}
dkc() {
  choice=$(fcontainer)
  if [ -n "$choice" ]; then
    print -z docker kill $@ "$choice"
  fi
}
drmc() {
  choice=$(fcontainerall)
  if [ -n "$choice" ]; then
    print -z docker rm $@ "$choice"
  fi
}
drmi() {
  choice=$(fimage)
  if [ -n "$choice" ]; then
    print -z docker rmi $@ "$choice"
  fi
}
