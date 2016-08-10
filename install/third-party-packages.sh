#!/usr/bin/env bash
set -e
set -u

read -p "Install Slack?"                       -n 1 -r      install_slack
echo

case $install_slack in
  y)
    url="https://downloads.slack-edge.com/linux_releases/slack-desktop-2.1.0-amd64.deb"
    curl -o /tmp/slack.deb $url
    sudo apt-get install gvfs-bin
    sudo dpkg -i /tmp/slack.deb
    ;;
esac

