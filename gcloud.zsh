function gcloud-configurations-activate {
  choice=$(gcloud config configurations list |
    fzf --header-lines=1 |
    awk '{print $1}'
  )
  if [ -n "$choice" ]; then
    cmd="gcloud config configurations activate $choice"
    print -s $funcstack[1]
    print -s $cmd
    eval $cmd
  fi
}
