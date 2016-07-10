alias gs='git status -sb'
alias gd='git diff'
alias gdc='git diff --cached'
alias gl='git log --decorate'
alias glogS='git log -p -S '
alias gf='git fetch'
alias gcommit='git commit -v -S'
alias gcheckout='git checkout '
alias gshow='git show '
alias gpush='git push '
alias greset='git reset '
alias gpull='git pull --rebase'
alias gclone='git clone '
alias gstash='git stash '
alias gadd='git add '
alias gtags='git tag --list | sort -V'
alias gtags-latest='git tag --list | sort -V | tail -n 1'
alias gci-status='hub ci-status '

# Initiate _git which exposes the _git-* completions
_git

gcc() {
  print -z git checkout $@ `fcommit`
}
# TODO: When checking out a remote branch, checkout with -b so that we don't end up in detached
# state.
gcb() {
  print -z git checkout $@ `fbranch`
}

compdef _git-checkout gcc gcb

grebasecommit() {
  print -z git rebase -i $@ `fcommit`
}

grebasebranch() {
  print -z git rebase -i $@ `fbranch`
}

compdef _git-rebase grebasecommit grebasebranch

goneline() {
  n=${1:-10}
  git log --pretty=oneline --decorate=short --reverse | tail -n $n
}

gresetcommit() {
  print -z git reset $@ `fcommit`
}

gresetbranch() {
  print -z git reset $@ `fbranch`
}

compdef _git-reset gresetcommit gresetbranch

gsha1() {
  print -z `fcommit`
}

_local_branch() {
  git symbolic-ref --short HEAD
}

_remote_branch() {
  remote=$(git remote)
  if [ $? != 0 ]; then
    return 1 # Returning $? will return the output of the if test. lol...
  fi

  if [ $(echo $remote | wc -l) == 1  ]; then
    branch=$(_local_branch)
    echo "$remote $branch"
  else
    echo 'More than 1 remote, specify which one to pull from'
    git remote
    return 1
  fi
}

gpullbranch() {
  branch=$(_remote_branch)
  [ $? == 0 ] && print -z git pull $@ $branch
}
compdef _git-pull gpullbranch

gpushbranch() {
  branch=$(_remote_branch)
  [ $? == 0 ] && print -z git push $@ $branch
}
compdef _git-push gpushbranch

gcherry() {
  current_branch=$(git symbolic-ref --short HEAD)
  unmerged_branch=$(git branch --no-merged $current_branch | cut -c 3- | fzf)
  commits=$(git rev-list $unmerged_branch --not $current_branch --no-merges --pretty=oneline | fzf -m)
  num_commits=$(echo $commits | wc -l)

  if [[ $num_commits -gt '2' ]]; then
    echo "Select 1 to 2 commits, starting at the oldest commit"
  elif [[ $num_commits -eq '1' ]]; then
    commit=$(echo $commits | awk '{print $1}')
    print -z git cherry-pick $commit
  elif [[ $num_commits -eq '2' ]]; then
    first=$(echo $commits | awk '{if (NR==1) print $1}')
    second=$(echo $commits | awk '{if (NR==2) print $1}')
    print -z git cherry-pick $first..$second
  fi
}
