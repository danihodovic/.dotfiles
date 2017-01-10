#!/usr/bin/env bash

# TODO: Add description/usage

set -e

modprobe_file_path=/etc/modprobe.d/hid_apple.conf
config_file_contents=$(cat <<-END

options hid_apple swap_fn_leftctrl=1
options hid_apple ejectcd_as_delete=0
options hid_apple swap_opt_cmd=1
options hid_apple fnmode=2

END
)

function populate_config_file {
  echo [Populating config file...]
  echo "$config_file_contents" | sudo tee "$modprobe_file_path" > /dev/null
}

function apply_hid_apple_patch {
  echo [Applying hid_apple_patch...]
  tempdir=$(mktemp -d)
  cd "$tempdir"
  git clone https://github.com/free5lot/hid-apple-patched.git
  cd hid-apple-patched
  ./build.sh
  ./install.sh
}

function main {
  populate_config_file
  apply_hid_apple_patch
}

main
