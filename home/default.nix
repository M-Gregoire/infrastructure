{ config, ... }:

{
  imports = [ ./home.nix ];

  home.activation = {
    rofi = ''
      if [ -d "${config.resources.paths.home}/.config" ]; then
        mkdir -p ${config.resources.paths.home}/.config/rofi
        cd ${config.resources.paths.home}/.config/rofi
        for d in *; do
          # If link broken, delete
          if [ ! -e "$d" ] ; then
            rm -f $d
          fi
	done
        for d in ${config.resources.paths.publicConfig}/vendor/rofi/1080p/*; do
	  f=$(basename "$d")
          if [[ ! -L "$f" ]]; then
             ln -s ${config.resources.paths.publicConfig}/vendor/rofi/1080p/$f $f
          fi
        done
        if [[ ! -L "pywal.rasi" ]]; then
            ln -s ${config.resources.paths.home}/.cache/wal/colors-rofi-dark.rasi pywal.rasi
        fi
	# Modify the scripts to get all parameters from environment variables
	for val in "theme" "color" "shutdown" "reboot" "lock" "suspend" "logout"; do
	    sed -i "s/^$val/#$val/" ${config.resources.paths.publicConfig}/vendor/rofi/1080p/powermenu/powermenu.sh
	    sed -i "s/^$val/#$val/" ${config.resources.paths.publicConfig}/vendor/rofi/1080p/launchers/ribbon/launcher.sh
	done
      fi
    '';

    polybar = ''
      if [ -d "${config.resources.paths.home}/.config/polybar" ]; then
        cd ${config.resources.paths.home}/.config/polybar
        for d in pulseaudio-control.bash; do
          if [ ! -e "$d" ] ; then
            rm -f $d
          fi
          if [[ ! -L "$d" ]]; then
            ln -s ${config.resources.paths.publicConfig}/vendor/polybar-pulseaudio-control/$d $d
          fi
        done
      fi
    '';

    folders = ''
      mkdir -p ${config.resources.paths.home}/src/
      mkdir -p ${config.resources.paths.home}/Screenshots/
    '';
  };
}
