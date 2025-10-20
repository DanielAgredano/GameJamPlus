#!/bin/sh
printf '\033c\033]0;%s\a' GameJamPlus
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Perifronisi.x86_64" "$@"
