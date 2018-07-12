alias gs='git status -sb'
alias gd='git diff'
alias gdc='git diff --cached'
alias gl='git log --decorate'
alias glogS='git log -p -S '
alias gcommitgrep='git log --grep '
alias gpickaxe='git log -p -S '
alias gf='git fetch --prune'
alias gcommit='git commit'
alias gca='git commit -a'
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
alias gl-last-tag-to-HEAD='git log $(git tag --list | sort -V | tail -n 1)..master'
alias gremotes='git remote -v'
alias gremote='git remote'
function gdom {
  query=$1
  default_remote_branch=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')
  if [[ "$query" == "--stat" ]]; then
    git diff origin/$default_remote_branch --stat
    return
  fi

  file=$(
    git diff origin/"$default_remote_branch" --stat --color=always | \
    fzf --query=$query --ansi --prompt "GitFiles?> " \
      --preview="git diff origin/$default_remote_branch --color=always {1}" | \
    awk '{print $1}'

  )
  [ ! -z $file ] && git diff origin/$default_remote_branch $file
}

function grom {
  default_remote_branch=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')
  git fetch
  git rebase origin/"$default_remote_branch"
}

gdob () { git diff origin/$(_local_branch) $@ }
compdef _git-diff gdob

alias ci-status='hub ci-status'
alias pr='gpushbranch && hub pull-request'

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
  if [ -n "$1" ]; then
    git show "$1"
  else
    local commit=`fcommit`
    if [[ -n $commit ]]; then
      cmd="git show $@ $commit"
      print -s $cmd
      eval $cmd
    fi
  fi
}

gcheckoutcommit() {
  local commit=`fcommit`
  if [[ -n $commit ]]; then
    cmd="git checkout $@ $commit"
    print -s $cmd
    eval $cmd
  fi
}

gcheckoutbranch() {
  local branch_name=$(fbranch)
  if [[ $branch_name =~ ^origin ]]; then
    # Strip the origin part. If we don't do this it won't checkout a new branch but will be in
    # detached state
    branch_name=$(echo $branch_name | sed -e 's/^origin\///')
  fi
  if [[ -n $branch_name ]]; then
    cmd="git checkout $@ $branch_name"
    print -s $cmd
    eval $cmd
  fi
}

gresetbranch() {
  local branch_name=$(fbranch)
  if [[ -n $branch_name ]]; then
    cmd="git reset $@ $branch_name"
    print -s $cmd
    eval $cmd
  fi
}
compdef _git-reset gresetbranch

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

# TODO: FZF preview window commit message
goneline() {
  git log --pretty=oneline --decorate=short | \
    fzf | \
    awk '{print $1}' | \
    tr -d '\n' | \
    xclip -selection clipboard
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

function delete_dead_branches {
  dead_branches=$(git branch --merged=master | egrep --invert-match '(master|production)')
  echo $dead_branches | while read branch; do
    # If branch name does not contain just whitespace
    if [[ $branch = *[![:space:]]* ]]; then
      git branch -d $branch
    fi
  done
}

gpullbranch() {
  branch=$(_local_branch)
  if [ $? = 0 ]; then
    git fetch --prune
    git rebase $@ origin/$branch
    delete_dead_branches
  fi
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
    print -z git cherry-pick "$commit"
  elif [[ $num_commits -eq '2' ]]; then
    first=$(echo $commits | awk '{if (NR==1) print $1}')
    second=$(echo $commits | awk '{if (NR==2) print $1}')
    cmd="git cherry-pick \"$first^..$second\""
    print -s $cmd
    eval "$cmd"
  fi
}

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
