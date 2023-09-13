#!/usr/bin/env bash

# Run xidlehook
xidlehook \
  `# Don't lock when there's a fullscreen application` \
  --not-when-fullscreen \
  `# Don't lock when there's audio playing` \
  --not-when-audio \
  # TODO: Dim screen here
  `# Dim the screen after 45 seconds, undim if user becomes active` \
  --timer 45 \
    # 'echo "1"; systemctl --user stop redshift; pkill redshift; redshift -x; redshift -l $LATITUDE:$LONGITUDE -O $CURRENT_COLOR -P -r -b $DIMMED_BRIGHTNESS:$DIMMED_BRIGHTNESS' \
    # 'echo "2"; redshift -x; systemctl --user start redshift' \
  `# Undim & lock after 60 more seconds` \
  --timer 60 \
    'echo "3"; i3lock-fancy;' \
    '' \
  `# Finally, suspend an hour after it locks` \
  --timer 3600 \
    'systemctl suspend' \
    ''
