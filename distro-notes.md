# Using gpg-agent and signing commits with gpg

This section assumes you have generated a private gpg key.

gpg and gpg-agent seem to be very difficult to get going. One possible reason for this is that the
default gpg installed on Ubuntu systems (16.04 at the time of writing) is version 1.40 while
gpg-agent is v2.1. gpg2 seems to be far more user friendly and directed at desktops while gpg is
directed at servers.

In order to avoid typing in your gpg passphrase for every commit install gpgv2 and gpg-agent (which
should also be v2).

    sudo apt-get install gnupg2
    sudo apt-get install gpg-agent

Configure git to use gpg2 by default

    git config --global gpg.program gpg2

Also remember to have your gpg key email match the email set for git

    git config --global user.email <email>


Note: If you don't want to use a pinentry with GUI to store your password, such as pinentry-curses
you will have to expose a tty for the gpg-agent.

Add the following to your .zshrc

    export GPG_TTY=`tty`

And add this to ~/.gnupg/gpg-agent.conf

    pinentry-program /usr/bin/pinentry-curses

For i3 it is recomennded you use pinentry-curses as pinentry-gtk-2 and pinentry-gnome3 seem to
break.

Also note that using gnome-keyring-daemon seems to interfere with the gpg-daemon; even if it's only
used for ssh. An alternative is to use keychain for the ssh keys as it doesn't conflict with
gpg-agent. However if you use keychain you will have to add the following lines in your .zshrc

    keychain ${HOME}/.ssh/id_rsa
    source ${HOME}/.keychain/mbp-sh

# Changing gpg-agent passphrase
It seems like gpg and gpg2 use different passphrases to protect the key. To change the one the
gpg-daemon uses you need to use gpg2. In case you want to change the passphrase gpg uses use `gpg`
instead of `gpg2`.

    $ gpg2 --edit-key <your key>
    > passwd
    > save

    $ killall gpg-agent

# Changing the ssh key passphrase

    $ ssh-keygen -p -f ~/.ssh/id_rsa

# Set maximum cache time on gpg-agent
"Set it to a year or so – say, 34560000 seconds (400 days) – and you should be fine:"

    default-cache-ttl 34560000

Note: In GnuPG 2.1 and above, the maximum-cache-ttl option was renamed to max-cache-ttl without
further changes.

http://superuser.com/questions/624343/keep-gnupg-credentials-cached-for-entire-user-session

# Using OpenVPN and gnome-network-manager

This configuration uses NordVPN as an example

Install openvpn and download the NordVPN configuration files and certificates

    sudo apt-get install openvpn
    cd /etc/openvpn
    sudo curl -O https://nordvpn.com/api/files/zip
    sudo unzip zip
    sudo rm zip

Install network-manager-openvpn to select a vpn connection using the applet

    sudo apt-get install network-manager-openvpn
    sudo apt-get install network-manager-openvpn-gnome

Import the .ovpn file in the network manager gui applet

1. Right click the applet -> Edit Connections
2. Click Add
3. Choose a connection type -> Import a saved VPN configuration
4. Point to one of your downloaded NordVPN .ovpn files
5. Enter your NordVPN credentials
6. Connect

## Cinnamon

### Disable alt-` to switch window groups
Install dconf-editor
Launch dconf-editor
Locate

	/org/gnome/desktop/wm/keybindings
	and
	/org/cinnamon/desktop/keybindings/wm

Find the option switch group
Find the definition for switch-group. It should be set to ['<Alt>AboveTab']
Change this to something else
You need to log out of cinnamon for this to work

### Disable ctrl-alt-l to lock screen
Launch dconf-editor
Locate

	/org/cinnamon/desktop/keybindings/media-keys

Find the option `screensaver` and disable it.
Strangely, you don't need to log out of cinnamon for this to work.



# Xubuntu/Lubuntu/Any system that uses xkb:

## How to customize keyboard/swap keys
This can be done using xkb or xmodmap. Ubuntu and most other distros use xkb which is easier to
setup so that it can be handled on startup and after suspension without having to fiddle with
scripts.

Many common options are predefined in xkb such as swapping esc and caps. If your options are not
defined you probably need to fiddle with the pesky config. Here's an example of how to swap curly
braces and square brackets on an US keyboard.

1. Edit /usr/share/x11/xkb/symbols/us
2. Find the keys you want to swap, for us it's braceleft, braceright, bracketleft, bracketright.
   (Key names can be found using xev)
3. Swap the keys.

By default (line 30ish):

    key <AD11> {	[ bracketleft,	braceleft	]	};
    key <AD12> {	[ bracketright,	braceright	]	};

After swap:

    key <AD11> {	[ braceleft,	bracketleft	]	};
    key <AD12> {	[ braceright,	bracketright	]	};

Reconfigure xkb-data: `sudo dpkg-reconfigure xkb-data`

If changing the system wide files you don't have to deal with startup scripts as you have to do with
-options.

## Customizing a 68 key mechanical keyboard (Magicforce) to swap caps, escape, tilde, grave
The keyboard has only 68 keys and therefore maps Esc, tilde and grave into one key. By default this
forces you to use the modifier and shift keys for tilde which we don't want.

Add the remapping in `/usr/share/X11/xkb/symbols/capslock`

    hidden partial modifier_keys
    xkb_symbols "swapescape68" {
        key <CAPS> { [ Escape ] };
        key <ESC>  { [ grave ] };
        key <TLDE> { [ grave, asciitilde ] };
    };

Add the rule in `/usr/share/X11/xkb/rules/evdev`

    // The preceeding line looks like this: caps:swapescape   = +capslock(swapescape)
    caps:swapescape68 = +capslock(swapescape68)

Reconfigure xkb-data (or reboot)

    sudo dpkg-reconfigure xkb-data

Enable it with:

    setxkbamp -option caps:swapescape68

# Lubuntu:
## How to add shortkeys:
Run `openbox --reconfigure` to generate the xml file.
Add to `.conf/openbox/lubuntu-rc.xml` in keyboard entries

Example:
`
<keybind key="A-section">
  <action name="Execute">
    <command>dmenu_run -fn "Monaco-16:bold" -l 5 -i -b -nb "#000" -nf "#FFF" -sb "#FF3399"</command>
  </action>
</keybind>
`
Rerun `openbox --reconfigure`

## Add a keychain and ssh-agent so that you don't need to re-enter passwords
http://www.cyberciti.biz/faq/ssh-passwordless-login-with-keychain-for-scripts/

	keychain --quiet $HOME/.ssh/id_rsa
	source $HOME/.keychain/$HOST-sh

## How to fix Skype:

Turn PulseAudio autospawn off, normally: $ echo "autospawn = no" > ~/.pulse/client.conf
Kill PulseAudio: $ killall pulseaudio
Shut down and restart Skype

Software:
xfce4-screenshooter-plugin


## Fix volume keyboard keys on Lubuntu with pulseaudio cli
Edit .config/openbox/lubuntu-rc.xml
    <keybind key="XF86AudioRaiseVolume">
      <action name="Execute">
	<command>pactl set-sink-volume 0 +10%</command>
	<!--<command>echo "world" > ~/openboxtest</command>-->
      </action>
    </keybind>
    <keybind key="XF86AudioLowerVolume">
      <action name="Execute">
        <command>pactl set-sink-volume 0 -10%</command>
      </action>
    </keybind>
    <keybind key="XF86AudioMute">
      <action name="Execute">
        <command>pactl set-sink-mute 0 toggle</command>
      </action>
    </keybind>

# Debian
Compared to Ubuntu and Linux Mint, Debian is **very** barebones. Aside from missing firmware, a lot of
essential packages, such as  `keyboard-configuration` and `software-properties-common`
(package that enables `apt-add repository`) are not installed by default.

Debian has a million different versions of the OS to install. If you want a recovery live-usb you probably
don't want to use the net installation iso (although this is the smallest). If you do install a live-usb
distro, **make sure** to pick one with third-party firmware so that these packages don't need to be installed
afterwards (especially tricky without a connection) or download the firmware on a usb stick.

Most of the debian iso's can be found here: http://cdimage.debian.org/cdimage/unofficial/
Nonfree recommended: http://cdimage.debian.org/cdimage/unofficial/non-free/cd-including-firmware/
If you have a wired connection, you can install the small netinst image. If not, go for the larger iso.

### Reconfiguring keyboard layout
See: https://wiki.debian.org/Keyboard

Via the `keyboard-configuration` package:

	sudo apt-get install keyboard-configuration
	dpkg-reconfigure keyboard-configuration
	# ...Go through the terminal UI guide
	service keyboard-setup restart

Or, if running X11, you can use `setxkbmap`

	setxkbmap us # setxkbmap se

# Other

## Testing terminals for truecolor support
Run this perl script: https://github.com/robertknight/konsole/blob/master/tests/color-spaces.pl
Also see: https://gist.github.com/XVilka/8346728

## Disable gnome-terminal confirmation when closing window
	/org/gnome/terminal/legacy -> uncheck the confirm-close

## Adding true color support to gnome terminal
http://askubuntu.com/questions/512525/how-to-enable-24bit-true-color-support-in-gnome-terminal

sudo add-apt-repository ppa:gnome3-team/gnome3-staging
sudo apt-get update
sudo apt-get install gnome-terminal
sudo add-apt-repository -r ppa:gnome3-team/gnome3-staging

## Gnome-terminal colorschemes
github.com/metalelf0/gnome-terminal-colors

## Useful commands for loading/unloading kernel drivers

identify wifi card

	# Look for `Kernel driver in use: <here>` on the last line
	lspci -vvnn | grep -A 9 Network

list all PCI devices

	# -vv is very verbose. Prints useful info nicely
	# Look for the Network category
	lspci -vv

remove kernel module

	sudo modprobe -r <module>

list loaded kernel modules

	lsmod

# Mac


# Installing Linux on Mac
Some Linux distros don't support EFI booting, so creating a bootable USB with the usual
tools such as `usb-creator-gtk` and `unetbootin` doesn't work.
`Mac-Linux-USB-Loader` is an OSX app which creates bootable USB's for Mac.
https://github.com/SevenBits/Mac-Linux-USB-Loader

For a Linux Mint installation, mark it as Ubuntu in the Mac-Linux-USB-Loader Gui.
Check both boxes

- [x] This ISO lacks an EFI-enabled kernel.
- [x] This ISO has code older than Ubuntu 14.10

It probably won't boot otherwise.

# Known issues for the 2015 Macbook (trackpad, swapping control keys)

It seems like the trackpad and the swapping of control keys using `/etc/modprobe.d/hid_apple.conf` does
not work for kernels earlier than 4.2.0. Ubuntu-based distros ship with 4.2 starting from Ubuntu version 15.10,
so Ubuntu-spinoffs (Xubuntu, Mint) need to be based on at least this version for basic features to work.
Linux Mint 17 ships with 3.x because it's based on Ubuntu LTS (14.04) so the trackpad doesn't work by default.

Issues:

- Trackpad scrolling doesn't work.
- Trackpad double click doesn't work.
- Swapping control keys by editing `/etc/modprobe.d/hid_apple.conf` doesn't work (fn-ctrl, cmd-option, fn-keys).


## Native Xubuntu/Cinnamon on Mac

### Hardware
#### macfanctld - Daemon that reads temperature and adjusts the fan speed
Installing macfanctld to keep it from overheating
Run it in the foreground

	sudo apt-get install macfanctld
	sudo macfanctld -f

#### General power management
Install tlp:
http://linrunner.de/en/tlp/docs/tlp-linux-advanced-power-management.html
	apt-add-repository ppa:linrunner/tlp
	tlp start
Tlp will run on startup by default. In order to check if it's running try
	sudo tlp-stat


#### Reducing brightness
Run xrandr to find the connected display

	xrandr -q | grep connected

Reduce the brightness of the ePS display

	xrandr --ouput <ePS?> --brightness 0.5

### Remapping keys

#### Swapping fn-ctrl on a Mac

Swapping fn-ctrl keys is provided by a patch on the hid-apple module found in this repo
https://github.com/free5lot/hid-apple-patched.git. The patch has not reached the Linux kernel
yet. The repo states that it works up to kernel 4.2, however it seems to work up to
kernel 4.4.0-040400rc7-generic.

TODO: Make this a script

Install the Linux kernel headers (the patch depends on these).

    # You might need to install the linux headers
    # sudo apt-get install linux-headers-$(uname -r)

Install https://github.com/free5lot/hid-apple-patched

    git clone https://github.com/free5lot/hid-apple-patched.git
    cd hid-apple-patched.git
    ./build.sh
    ./install.sh

#### Swapping command-option

TODO: Make this a script

https://help.ubuntu.com/community/AppleKeyboard#Mapping_keys_.28Insert.2C_Alt.2C_Cmd.2C_etc..29

edit /etc/modprobe.d/hid_apple.conf

add:

    options hid_apple swap_opt_cmd=1

run:
    sudo update-initramfs -u -k all

reboot

#### Enabling fn-keys properly

TODO: Make this a script

https://help.ubuntu.com/community/AppleKeyboard#Change_Function_Key_behavior

edit /etc/modprobe.d/hid_apple.conf
add  options hid_apple fnmode=2
run  sudo update-initramfs -u -k all
reboot

#### Vagrant nfs on linux
sudo apt-get install nfs-kernel-server

Vagrant issue when copying a Mac setup to Linux:
replace

    config.vm.synced_folder ".", "/vagrant", type: "nfs", mount_options: ['actimeo=1'], nfs_version: 4

with

    config.vm.synced_folder ".", "/vagrant", type: "nfs", mount_options: ['actimeo=1,v3']

## HIDPI support
Works by default using cinnamon. Either install Linux mint or install the
cinnamon ppa - ppa:kranich/cinnamon

## Other
Fix C-h for tmux and Neovim, see https://github.com/neovim/neovim/issues/2048

	infocmp $TERM | sed 's/kbs=^[hH]/kbs=\\177/' > $TERM.ti
	tic $TERM.ti

#Installing sopcast on Ubuntu 14/15/16

    dpkg --add-architecture i386
    apt-get update
    apt-get install libstdc++5:i386 curl -y

    curl -O http://download.sopcast.com/download/sp-auth.tgz
    tar -xf sp-auth.tgz
    ./sp-auth/sp-sc-auth

#Configuring ec2 for ssh access
1. Launch an ec2 instance in the aws console
2. Create a security group which allows inbound port 22 in the aws console
3. Genetate a keypair in the aws console
4. Download the keypair

Optional, configure ~/.ssh/config

    Host ec2
        HostName xxxxxxx
        Port 22
        User ubuntu # This is important!
        IdentityFile ~/.ssh/your-file.pem

Optional, change the default ssh port

1. Ssh into your ec2 instance
2. Edit /etc/ssh/sshd_config. Change the port setting to your desired port
3. Edit the security group in the aws console to allow the desired port
4. Restart sshd `service ssh restart`

# Xsession loops login
If it turns out that you try to login and it loops you back to the login screen, something is wrong
with your xsession. Debug by running

    # Enter a tty (Ctrl + Alt + F1) and login
    cat ~/.xsession-errors

# Docker

## Docker daemon fails to start with Linux kernel 4.7
http://stackoverflow.com/a/37640824/2966951

This also applies to a 'hanging' docker installation that gets stuck on

    Setting up docker-engine (1.12.0-0~xenial) ...

This is because the service can't be started

    http://unix.stackexchange.com/questions/293675/installing-docker-hangs-at-setting-up-docker-engine-on-ubuntu-xenial

### library/mysql does not execute prepare.sql in a mounted volume

Stupid issue. If the permissions are wrong on the host, the mysql user won't be able to see the
script and can't execute the entrypoint script properly.

# Java: Setting up eclipse, eclim and vim

## Installing

Install eclipse

    curl -o eclipse.tar http://mirror.netcologne.de/eclipse//technology/epp/downloads/release/mars/2/eclipse-java-mars-2-linux-gtk-x86_64.tar.gz
    tar -C /opt -xzf eclipse.tar # Assumes /opt is owned by user
    rm eclipse.tar

Install eclim using the unattended installation method

    curl -o eclim.jar http://netix.dl.sourceforge.net/project/eclim/eclim/2.5.0/eclim_2.5.0.jar
    java -Declipse.home=/opt/eclipse  -jar ~/Downloads/eclim_2.5.0.jar
    rm eclim.jar

Install the vim plugin by adding `Plug 'dansomething/vim-eclim'` to you vim file.

## Running eclim
Launch the eclimd daemon

    /eclipse/eclimd

Notes:

- Start new projects using eclipse GUI, otherwise things get nasty as .project and .classpath files
  are required which are generated by eclipse.
- If you plan on adding jars use the eclipse GUI.
- When opening a project in eclipse and vim run `:ProjectOpen <project name in eclipse>`


## References:
http://eclim.org/install.html
https://github.com/dansomething/vim-eclim

# Installing virtualbox-dkms on Ubuntu 16 (kernel > 4.4)

It seems like kernel > 4.4 has some signing issues when installing virtualbox-dkms.
See: https://bugs.launchpad.net/ubuntu/+source/virtualbox/+bug/1574300

Steps to fix:

    $ sudo apt install mokutil
    $ sudo mokutil --disable-validation
    $ sudo dpkg-reconfigure virtualbox-dkms
    $ sysctl stop virtualbox
    $ sysctl start virtualbox

If the above solution does not work try this:

    # If the below command doesnt work due to a recent kernel version, download the headers
    # from http://kernel.ubuntu.com/~kernel-ppa/mainline/.
    # The required headers seem to be -generic
    sudo apt-get install linux-headers-`uname -r`
    sudo dpkg-reconfigure virtualbox-dkms


### Tags: virtualbox, virtualbox-dkms, kubernetes, minikube, vboxdrv(?)
