#!/usr/bin/env bash

#----------------------------------------------
# Scripts that installs:
# - Scala from the Scala deb repos
# - Sbt
# - Eclipse + Eclim
#----------------------------------------------



read -p "Install Scala? [y/n]"  PARAM_SCALA
read -p "Install SBT? [y/n]"    PARAM_SBT
read -p "Install eclim? [y/n]"  PARAM_ECLIM
#----------------------------------------------
# Scala
#----------------------------------------------

case $PARAM_SCALA in
    [yY])
        read -p "Enter Scala version:"  SCALA_VERSION
        echo "Installing scala..."
        sudo apt-get remove scala scala-library -y
        SITE="http://www.scala-lang.org/files/archive/"
        DEBFILE="scala-$SCALA_VERSION.deb"

        wget "$SITE$DEBFILE"
        sudo dpkg -i $DEBFILE
        rm $DEBFILE
        ;;
esac

#----------------------------------------------
# SBT
#----------------------------------------------

case $PARAM_SBT in
    [yY])
        echo "Installing SBT..."
        echo "deb http://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list
        sudo apt-get update
        sudo apt-get install sbt --force-yes
        ;;
esac

#----------------------------------------------
# Eclipse & Eclim
#----------------------------------------------

case $PARAM_ECLIM in
    y|Y )
        # Note that this is a direct download link without any redirects found on the eclipse site.
        # If you need a newer version of eclipse or eclim update the links
        ECLIPSE_URL="https://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/luna/SR2/eclipse-java-luna-SR2-linux-gtk-x86_64.tar.gz&r=1"
        ECLIM_URL="http://sourceforge.net/projects/eclim/files/eclim/2.4.1/eclim_2.4.1.jar/download"
        if [ ! -d "/opt/eclipse" ]; then
            echo "Installing Eclipse..."
            wget -nv -O- $ECLIPSE_URL | tar -xzv -C /opt
        else
            echo "Eclipse already installed"
        fi

        # Eclim installation creates a symlink for the daemon in the eclipse dir
        if [ ! -h "/opt/eclipse/eclimd" ]; then
            echo "Installing Eclim..."
            wget -nv -O /tmp/eclim.jar $ECLIM_URL
            java -jar /tmp/eclim.jar
        else
            echo "Eclim already installed"
        fi
        ;;
esac
