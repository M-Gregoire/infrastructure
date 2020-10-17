#!/usr/bin/env bash

export CURRENT_BRIGHTNESS="$(redshift -l $LATITUDE:$LONGITUDE -p 2> /dev/null | awk '/Brightness/{print $2}')"
export DIMMED_BRIGHTNESS="$(echo $CURRENT_BRIGHTNESS - 0.3 | bc)"

export CURRENT_COLOR="$(redshift -l $LATITUDE:$LONGITUDE -t $REDSHIFT_TEMP_DAY:$REDSHIFT_TEMP_NIGHT -b $DIMMED_BRIGHTNESS:$DIMMED_BRIGHTNESS -p 2> /dev/null | awk '/Color temperature/{print $3}')"

# Run xidlehook
xidlehook \
  `# Don't lock when there's a fullscreen application` \
  --not-when-fullscreen \
  `# Don't lock when there's audio playing` \
  --not-when-audio \
  `# Dim the screen after 45 seconds, undim if user becomes active` \
  --timer 45 \
    'echo "1"; systemctl --user stop redshift; pkill redshift; redshift -x; redshift -l $LATITUDE:$LONGITUDE -O $CURRENT_COLOR -P -r -b $DIMMED_BRIGHTNESS:$DIMMED_BRIGHTNESS' \
    'echo "2"; redshift -x; systemctl --user start redshift' \
  `# Undim & lock after 60 more seconds` \
  --timer 60 \
    'echo "3"; i3lock-fancy; redshift -x; systemctl --user start redshift' \
    '' \
  `# Finally, suspend an hour after it locks` \
  --timer 3600 \
    'systemctl suspend' \
    ''
