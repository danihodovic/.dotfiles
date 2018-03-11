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
    # Write the choice to a temporary file so that our shell prompt can be
    # updated.
    echo -n $choice > ~/.gcloud_active_configuration
  fi
}

# Any time the google cloud configuration changes we insert the active
# configuration to ~/.gcloud_active_configuration. This file is read by our zsh
# prompt notify us of the change. We could also read the value by parsing
# `$(gcloud config configurations list)`
# inside of our theme, but this command polls the server and makes our shell
# theme slow.
#
# Instead we achieve the same by (but faster) using a preexec hook which reads
# what project was last used and inserts it to a file. Our theme then reads that
# file and sets the zsh prompt.
#
# The shortcoming is that if we select an invalid project and the gcloud command
# exits with 1 our prompt will also show that invalid project even if it was
# never set.
function write_active_cloud_configuration () {
  if [[ "$1" =~ "^gcloud config configurations activate.*" ]]; then
    last_arg=$(echo $1 | awk '{print $NF}')
    echo -n $last_arg > ~/.gcloud_active_configuration
  fi
}

autoload -Uz add-zsh-hook
add-zsh-hook preexec write_active_cloud_configuration
