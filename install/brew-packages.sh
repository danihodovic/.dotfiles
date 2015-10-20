brew install caskroom/cask/brew/brew-cask

# The default git slows down zsh, see
# https://github.com/robbyrussell/oh-my-zsh/issues/2189
brew install git

# Some core tools (such as ls) work differently depending on your system.
# Install the GNU command line utils instead of the BSD version
# Note: When installing brew packages that clash with the GNU versions, such as find and tar
# you have to provide --with-default-names to prevent brew from prepending them with `g`
brew install coreutils
# find, locate, xargs
brew install findutils --with-default-names
brew install gnu-sed --with-default-names
brew install gnu-tar --with-default-names
brew install gnu-which --with-default-names

# Remappings of ctrl and fn
brew cask install doublecommand
# Remap caps and escape, follow the guide at
# http://stackoverflow.com/a/8437594/2966951
brew cask install seil
# Remaping command-w and command-q
brew install bettertouchtool

brew cask install google-chrome
