echo "Setting global git settings"

git config --global user.name "Dani Hodovic"

git config --global core.editor nvim

git config --global pull.rebase true
# With this, "git pull --rebase" is the default form of pull FOR NEWLY CREATED
# BRANCHES; for branches created before this config option is set, pull.rebase
# true handles that
git config --global branch.autosetuprebase always
# Prevents us from having to do merge resolution for things we've already
# resolved before; see http://git-scm.com/blog/2010/03/08/rerere.html
git config --global rerere.enabled true
# This makes sure that push pushes only the current branch, and pushes it to the
# same branch pull would pull from
git config --global push.default upstream

git config --global alias.graph "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"
