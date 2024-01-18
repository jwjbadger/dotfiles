#!/bin/bash
eval $(xdotool getmouselocation --shell)
if (( $X > 1920 )); then
	maim -g 1920x1080+1920+0 | xclip -selection clipboard -t image/png
else
	maim -g 1920x1080+0+0 | xclip -selection clipboard -t image/png
fi
