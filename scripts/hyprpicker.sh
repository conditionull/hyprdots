#!/usr/bin/env sh

hex=$(hyprpicker -a)
[ -z "$hex" ] && exit 1

r=$((16#${hex:1:2}))
g=$((16#${hex:3:2}))
b=$((16#${hex:5:2}))

notify-send "$hex copied to clipboard" "rgb($r, $g, $b)"
