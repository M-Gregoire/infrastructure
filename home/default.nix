{ config, ... }:

{
  imports = [ ./home.nix ];

  home.activation = {
    rofi = ''
      if [ -d "${config.resources.paths.home}/.config" ]; then
        mkdir -p ${config.resources.paths.home}/.config/rofi
        cd ${config.resources.paths.home}/.config/rofi
        for d in bin scripts themes launchers config.rasi; do
          # If link broken, delete
          if [ ! -e "$d" ] ; then
            rm -f $d
          fi
          if [[ ! -L "$d" ]]; then
             ln -s ${config.resources.paths.publicConfig}/vendor/rofi/$d $d
          fi
        done
        if [ ! -e "$d" ] ; then
           rm -f $d
        fi
        if [[ ! -L "pywal.rasi" ]]; then
            ln -s ${config.resources.paths.home}/.cache/wal/colors-rofi-dark.rasi pywal.rasi
        fi
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
