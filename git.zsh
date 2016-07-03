alias gs='git status -sb'
alias gd='git diff'
alias gl='git log --decorate'
alias glogS='git log -p -S '
alias gf='git fetch'
alias gcommit='git commit -v -S'
alias gcheckout='git checkout '
alias gshow='git show '
alias gpush='git push '
alias greset='git reset '
alias gpull='git pull '
alias gclone='git clone '
alias gstash='git stash '
alias gadd='git add '
alias gtags='git tag --list | sort -V'
alias gtags-latest='git tag --list | sort -V | tail -n 1'
alias gci-status='hub ci-status '

gcc() {
  print -z git checkout `fcommit`
}
gcb() {
  print -z git checkout `fbranch`
}
grebasecommit() {
  print -z git rebase -i `fcommit`
}
grebasebranch() {
  print -z git rebase -i `fbranch`
}
goneline() {
  n=${1:-10}
  git log --pretty=oneline --decorate=short --reverse | tail -n $n
}
