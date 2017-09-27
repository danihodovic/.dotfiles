#!/usr/bin/env bash
workspaces=$(i3-msg -t get_workspaces)
current_workspace_num=$(echo "$workspaces" | jq '.[] | select (.focused== true).num')
i3-input -F "rename workspace to $current_workspace_num:%s" -P 'rename workspace:'
