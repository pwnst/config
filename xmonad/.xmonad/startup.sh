#!/bin/bash
feh --bg-scale /home/pwnst/Pictures/kFLGAsV.png  \
    & setxkbmap -layout us,ru -option 'grp:alt_space_toggle' \
    & kbdd \
    & xmonad

