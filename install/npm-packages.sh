#!/usr/bin/env bash
set -e

read -p "Install jscs? "                         -n 1 -r   param_jscs
read -p "Install jshint? "                       -n 1 -r   param_jshint
read -p "Install fixmyjs? "                      -n 1 -r   param_fixmyjs

read -p "Install Typescript? "                   -n 1 -r   param_typescript
read -p "Install clausreinke/typescript-tools? " -n 1 -r   param_ts_tools
read -p "Install vvakame/typescript-formatter? " -n 1 -r   param_ts_formatter

case $param_jscs in
    y|Y )
        npm install -g jscs;;
esac

case $param_jshint in
    y|Y )
        npm install -g jshint;;
esac

case $param_fixmyjs in
    y)
        npm install -g fixmyjs;;
esac

case $param_typescript in
    y|Y )
        npm install -g typescript;;
esac

case $param_ts_tools in
    y|Y )
        npm install -g clausreinke/typescript-tools;;
esac

case $param_ts_formatter in
    y|Y )
        npm install -g typescript-formatter;;
esac
