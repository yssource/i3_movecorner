#!/usr/bin/env bash
#
# Simply move mouse to corner with xdotool and let i3 move focused window to
# its position, handling edge detection for us.

preset=$1
keep_mouse='true'
{ read screen_name max_x max_y ; } < <(xrandr -q |
awk '/\yconnected\y/{ gsub("x|+", " ", $0); print $1 " " $4 " " $5}' | head -n 1)
# find 'connected', replace x/+ with space, print fields

half_x=$(( max_x / 2 ))
half_y=$(( max_y / 2 ))

<<PRESETS
  -  <x_pos> +
 _______________
|7      8      9|   -
|               |   ^
|4      5      6| y_pos
|               |   v
|1______2______3|   +

PRESETS

case $preset in  # X        Y
    '1') new_pos="0        $max_y";;
    '2') new_pos="$half_x  $max_y";;
    '3') new_pos="$max_x   $max_y";;
    '4') new_pos="0        $half_y";;
    '5') new_pos="$half_x  $half_y";;
    '6') new_pos="$max_x   $half_y";;
    '7') new_pos="0        0";;
    '8') new_pos="$half_x  0";;
    '9') new_pos="$max_x   0";;
    *) echo "i3_movecorner: Invalid preset \"$preset\"" >&2; exit 2;;
esac

eval $(xdotool getmouselocation --shell) # get current mouse position

xdotool mousemove --sync --screen $screen_name $new_pos
i3-msg 'move position mouse'

if [[ -n $keep_mouse ]]; then
    xdotool mousemove --sync $X $Y # reset to old mouse position
fi

exit 0
