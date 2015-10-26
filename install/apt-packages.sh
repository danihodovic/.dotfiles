read -p "Install Oracle java?"      INSTALL_JAVA
read -p "Install numix?"            INSTALL_NUMIX
read -p "Install suckless-tools?"   INSTALL_SUCKLESS

sudo apt-get update
sudo apt-get install zsh -y
sudo apt-get install tmux -y
# Allows copy from tmux
sudo apt-get install xclip
sudo apt-get install sshfs -y
sudo apt-get install curl -y
sudo apt-get install cmake -y
sudo apt-get install git-extras -y
sudo apt-get install python-dev -y
# Move to next monitor scripts
sudo apt-get install xdotool wmctrl -y

case $INSTALL_JAVA in
    y|Y)
        sudo add-apt-repository ppa:webupd8team/java -y
        sudo apt-get update
        sudo apt-get install oracle-java8-installer --yes
        ;;
esac


case $INSTALL_NUMIX in
    y|Y)
        sudo add-apt-repository ppa:numix/ppa -y
        sudo apt-get update
        sudo apt-get install numix-gtk-theme numix-icon-theme-circle -y
        ;;
esac


case $INSTALL_SUCKLESS in
    y|Y)
        sudo add-apt-repository ppa:minos-archive/main -y
        sudo apt-get update
        sudo apt-get install suckless-tools
        ;;
esac

