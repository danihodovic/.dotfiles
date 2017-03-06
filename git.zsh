alias gs='git status -sb'
alias gd='git diff'
alias gdc='git diff --cached'
alias gl='git log --decorate'
alias glogS='git log -p -S '
alias glgrep='git log --grep '
alias gf='git fetch --prune'
alias gcommit='git commit -S'
alias grebase='git rebase '
alias gnb='git checkout -b'
alias gcheckout='git checkout'
alias gpush='git push '
alias greset='git reset '
alias gpull='git pull --rebase'
alias gclone='git clone '
alias gstash='git stash '
alias gadd='git add '
alias gtags='git tag --list | sort -V'
alias gpushtags='git push origin --tags'
alias gtags-latest='git tag --list | sort -V | tail -n 1'
alias gremotes='git remote -v'
alias gremote='git remote'
alias gci-status='hub ci-status '
alias gdom='git diff origin/master'
alias grom='git rebase origin/master'
gdob () { git diff origin/$(_local_branch) $@ }
compdef _git-diff gdob

# Initiate _git which exposes the _git-* completions
_git

# Retrieve local and remote branches sorted by last commit to the branch
fbranch() {
  local branches=$(git branch --sort=committerdate -a |\
    cut -c 3- |\
    sed 's/^remotes\/origin\///' |\
    sed '/HEAD/d' |\
    uniq)

  local branch=$(echo $branches | fzf --ansi --exact --tac --multi)
  echo $branch
}

function gshow {
  local commit=`fcommit`
  [[ -n $commit ]] && git show $@ $commit
}

gcheckoutcommit() {
  local commit=`fcommit`
  [[ -n $commit ]] && print -z git checkout $@ $commit
}

gcheckoutbranch() {
  local branch_name=$(fbranch)
  if [[ $branch_name =~ ^origin ]]; then
    # Strip the origin part. If we don't do this it won't checkout a new branch but will be in
    # detached state
    branch_name=$(echo $branch_name | sed -e 's/^origin\///')
  fi
  [[ -n $branch_name ]] && eval git checkout $@ $branch_name
}

alias gcc=gcheckoutcommit
alias gcb=gcheckoutbranch
compdef _git-checkout gcheckoutcommit gcheckoutbranch

grbc() {
  local commit=`fcommit`
  [[ -n $commit ]] && print -z git rebase -i $@ $commit
}

grbb() {
  branch=`fbranch`
  [[ -n $branch ]] && print -z git rebase $@ origin/$branch
}

compdef _git-rebase grbc grbb

# TODO: Use fzf
goneline() {
  n=${1:-10}
  git log --pretty=oneline --decorate=short | tail -n $n
}

gresetcommit() {
  commit=`fcommit`
  [[ -n $commit ]] && print -z git reset $@ $commit
}

gresetbranch() {
  branch=`fbranch`
  [[ -n $branch ]] && print -z git reset $@ "$branch"
}

compdef _git-reset gresetcommit gresetbranch

gformatpatch() {
  commit=`fcommit`
  [[ -n $commit ]] && print -z git format-patch $@ $commit
}

grevert() {
  commit=`fcommit`
  [[ -n $commit ]] && print -z git revert $@ $commit
}

compdef _git-format-patch gformatpatch

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

  if [ $(echo $remote | wc -l) = 1  ]; then
    branch=$(_local_branch)
    echo "$remote $branch"
  else
    echo 'More than 1 remote, specify which one to pull from'
    git remote
    return 1
  fi
}

gpullbranch() {
  branch=$(_local_branch)
  [ $? = 0 ] && git fetch --prune && git rebase $@ origin/$branch
}
compdef _git-pull gpullbranch

gpushbranch() {
  branch=$(_remote_branch)
  [ $? = 0 ] && eval git push $@ $branch
}
compdef _git-push gpushbranch

alias gplb=gpullbranch
alias gpsb=gpushbranch

gcherry() {
  current_branch=$(_local_branch)
  unmerged_branch=$(git branch --no-merged $current_branch | cut -c 3- | fzf)
  commits=$(git rev-list $unmerged_branch --not $current_branch --no-merges --pretty=oneline --abbrev-commit | fzf -m)
  num_commits=$(echo $commits | wc -l)

  if [[ $num_commits -gt '2' ]]; then
    echo "Select 1 to 2 commits, starting at the oldest commit"
  elif [[ $num_commits -eq '1' ]]; then
    commit=$(echo $commits | awk '{print $1}')
    print -z git cherry-pick $commit
  elif [[ $num_commits -eq '2' ]]; then
    first=$(echo $commits | awk '{if (NR==1) print $1}')
    second=$(echo $commits | awk '{if (NR==2) print $1}')
    print -z git cherry-pick $first^..$second
  fi
}

gchangedfilesinbranch() {
  local changed_files=$(git --no-pager diff origin/master --name-only)
  local selected_files=$(echo $changed_files | fzf -m --preview 'git diff --color=always origin/master {}')
  local oneline=$(echo $selected_files | tr '\n' ' ')
  LBUFFER="${LBUFFER} $oneline"
  zle redisplay
}
zle -N gchangedfilesinbranch
bindkey -M vicmd '\-' gchangedfilesinbranch

function gdelbranch {
  branches=$(fbranch)
  if [ -z "$branches" ]; then
    echo Provide a branch name
    return
  fi
  while read -r branch; do
    git branch -d "$branch"
    git push origin --delete "$branch"
  done <<< $branches
}
compdef _git-branch gdelbranch

function gdeltag {
  tag_name=$1
  if [ -z "$tag_name" ]; then
    echo Provide a tag name
    return
  fi
  git tag -d "$tag_name"
  git push origin :"$tag_name"
}
compdef _git-branch gdeltag
