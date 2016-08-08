#!/usr/bin/env zsh
custom_ps_format='table {{.Names}}\t{{.Image}}\t{{.ID}}\t{{.Command}}\t{{.Ports}}\t{{.Mounts}}'

# $ docker ps --format=$custom_ps_format | awk '{if(NR>1) print}' | fzf | awk '{print $1 != "" ? $1 : $3}'

alias drun='docker run '
alias dstart='docker start '
alias dps="docker ps --format='$custom_ps_format'"
alias dbuild='docker build '
alias dbuildt='docker build -t '
alias dkill='docker kill '
alias dkillrunning='docker kill $(docker ps -q)'
alias dkillall='docker kill $(docker ps -a -q)'
alias dstop='docker stop '
alias dstoprunning='docker stop $(docker ps -q)'
alias dstopall='docker stop $(docker ps -a -q)'
alias drm='docker rm '
alias drmall='docker rm $(docker ps -a -q)'
alias dsearch='docker search '

alias dcbuild='docker-compose build'
alias dcup='docker-compose up'
alias dcdown='docker-compose down'
alias dcrun='docker-compose run --rm '
alias dcexec='docker-compose exec '
alias dclogs='docker-compose logs'

fcontainer() {
  echo "$(docker ps --format=$custom_ps_format | awk '{if(NR>1) print}' | fzf | \
    awk '{print $1 != "" ? $1 : $3}')"
}
fcontainerall() {
  echo "$(docker ps --format=$custom_ps_format -a | awk '{if(NR>1) print}' | fzf | \
    awk '{print $1 != "" ? $1 : $3}')"
}
fimage() {
  echo "$(docker images | awk '{if(NR>1) print}' | fzf | awk '{print $1}')"
}

dri() {
  choice=$(fimage)
  if [ -n "$choice" ]; then
    print -z docker run $@ "$choice"
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
