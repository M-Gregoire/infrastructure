{ config, ... }:

{
  imports = [ ./home.nix ];

  home.activation = {

    # I'm using rofi themes from https://github.com/adi1090x/rofi
    # But it needs a few changes to be able to select icons and theme from environment variables alone
    # This script patches it
    # TODO: This is sub-optimal as the vendor directory is modified and triggers a git change.
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

    folders = ''
      mkdir -p ${config.resources.paths.home}/src/
      mkdir -p ${config.resources.paths.home}/Screenshots/
    '';
  };
}
