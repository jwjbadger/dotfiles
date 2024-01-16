external_monitor=$(xrandr --query | grep 'HDMI-A-0')

if [[ $external_monitor = HDMI-A-0\ connected* ]]; then
	polybar -r side &
fi

polybar -r main &
