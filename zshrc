#!/usr/bin/env zsh

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
    start-tmux-if-exist

elif [[ "$(uname)" == "Darwin" ]]; then
    # Use GNU coreutils instead of bsd ones
    export PATH="$(brew --prefix coreutils)/libexec/gnubin:/usr/local/bin:$PATH"

else
    echo 'Unknown OS' $(uname)
fi

