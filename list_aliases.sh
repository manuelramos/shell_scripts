#!/bin/zsh
#
# This script shows the aliases defined for a specific tool in the .zshrc file.
#
# Usage: $0 tool_name
#
# The script looks for the line "#Aliases" in the .zshrc file and then looks for the
# line "#tool_name", where tool_name is the argument passed to the script. From there,
# the script prints all lines starting with "alias" until it finds another line starting
# with "#".
#
# The .zshrc file should be formatted as follows:
#
# #Aliases:
# #tool1
# alias ...
# alias ...
# #tool2
# alias ...
# alias...
#
# Note that the alias names should be preceded by "alias" and followed by "=". The
# script will highlight the alias name in red.

if [ $# -ne 1 ]; then
  echo "Usage: $0 tool_name"
  exit 1
fi

tool_name=$1
start_found=0
aliases_found=0

while read line
do
  # echo $line
  if [[ "$line" == "#Aliases:" ]]; then
    aliases_found=1
  fi

  if [[ "$aliases_found" -eq 1 ]]; then
    if [[ "$line" == "#$tool_name" ]]; then
      start_found=1
    fi

    if [[ "$start_found" -eq 1 ]]; then
      if [[ "$line" == "#"* ]] && [[ "$line" != "#$tool_name" ]]; then
        break
      elif [[ "$line" == "alias"* ]]; then
        alias_name=$(echo $line | awk '{print $2}' | cut -d "=" -f1)
        echo "$line" | sed "s/$alias_name/\x1b[31m$alias_name\x1b[0m/g"
      fi
    fi
  fi
done < ~/.zshrc
