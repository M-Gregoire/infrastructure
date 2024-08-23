{ config, lib, pkgs, ... }:

{
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
        for d in ${config.resources.paths.publicConfig}/vendor/rofi/files/*; do
          f=$(basename "$d")
          if [[ ! -L "$f" ]]; then
             ln -s ${config.resources.paths.publicConfig}/vendor/rofi/files/$f $f
          fi
        done
        if [[ ! -L "pywal.rasi" ]]; then
            ln -s ${config.resources.paths.home}/.cache/wal/colors-rofi-dark.rasi pywal.rasi
        fi
        # Set theme
        rm $HOME/.config/rofi/powermenu/type-2/shared/colors.rasi
        echo '@import "~/.config/rofi/colors/solarized.rasi"' > $HOME/.config/rofi/powermenu/type-2/shared/colors.rasi
        rm $HOME/.config/rofi/launchers/type-2/shared/colors.rasi
        echo '@import "~/.config/rofi/colors/solarized.rasi"' > $HOME/.config/rofi/launchers/type-2/shared/colors.rasi
        rm $HOME/.config/rofi/applets/shared/colors.rasi
        echo '@import "~/.config/rofi/colors/solarized.rasi"' > $HOME/.config/rofi/applets/shared/colors.rasi
        rm $HOME/.config/rofi/applets/shared/theme.bash
        echo 'type="$HOME/.config/rofi/applets/type-2"' > $HOME/.config/rofi/applets/shared/theme.bash
        echo "style='style-1.rasi'" >> $HOME/.config/rofi/applets/shared/theme.bash
      fi
    '';

  };
}
