# Cura settings

I use the default settings for "Prusa i3" with some modifications.

## Set correct nozzle size

Don't forget to set the correct nozzle size if you sometimes change it!

## Autolevel bed before print

In the start G-Code section, I added `G29` right after `G28` so that the bed is auto leveled before a print.
