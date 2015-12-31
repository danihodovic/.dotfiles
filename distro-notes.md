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
You don't need to logoff for this to work

### Disable ctrl-alt-l to lock screen
Launch dconf-editor
Locate

	/org/cinnamon/desktop/keybindings/wm

Find the option `screensaver` and disable it.



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

Clear the cache: `sudo rm /var/lib/xkb/*.xkm`

Reconfigure xkb-data: `sudo  dpkg-reconfigure xkb-data`

Reboot

If changing the system wide files you don't have to deal with startup scripts as you have to do with
-options.


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

Fix C-h for tmux and Neovim, see https://github.com/neovim/neovim/issues/2048

	infocmp $TERM | sed 's/kbs=^[hH]/kbs=\\177/' > $TERM.ti
	tic $TERM.ti
	
# Installing Linux on Mac
Some Linux distros don't support EFI booting, so creating a bootable USB with the usual
tools such as `usb-creator-gtk` and `unetbootin` doesn't work. 
`Mac-Linux-USB-Loader` is an OSX app which creates bootable USB's for Mac.
https://github.com/SevenBits/Mac-Linux-USB-Loader 

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

#### Swapping fn-ctrl

TODO: Make this a script

Install the Linux kernel headers (the patch depends on these).
    # You might need to install the linux headers
    # sudo apt-get install linux-headers-$(uname -r)

Install https://github.com/free5lot/hid-apple-patched

    git clone https://github.com/free5lot/hid-apple-patched.git
    cd hid-apple-patched.git
    ./build.sh
    ./install.sh


#### Enabling fn-keys properly

TODO: Make this a script

https://help.ubuntu.com/community/AppleKeyboard#Change_Function_Key_behavior

edit /etc/modprobe.d/hid_apple.conf
add  options hid_apple fnmode=2
run  sudo update-initramfs -u -k all
reboot

#### Swapping command-option

TODO: Make this a script

https://help.ubuntu.com/community/AppleKeyboard#Mapping_keys_.28Insert.2C_Alt.2C_Cmd.2C_etc..29

edit /etc/modprobe.d/hid_apple.conf
add  options hid_apple swap_opt_cmd=1
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




