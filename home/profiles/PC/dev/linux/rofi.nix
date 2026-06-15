{ config, lib, pkgs, flake-root, ... }:

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
        # Dirs that need local modifications (can't be nix store symlinks)
        for d in applets launchers powermenu; do
          if [ -L "$d" ]; then rm "$d"; fi
          if [ ! -d "$d" ]; then
            cp -r ${flake-root}/vendor/rofi/files/$d $d
            chmod -R u+w $d
          fi
        done
        # Everything else can be symlinked
        for d in ${flake-root}/vendor/rofi/files/*; do
          f=$(basename "$d")
          case "$f" in applets|launchers|powermenu) continue;; esac
          ln -sfn "$d" "$f"
        done
        rm -rf pywal.rasi
        ln -s $HOME/.cache/wal/colors-rofi-dark.rasi pywal.rasi
        # Set theme
        echo '@import "~/.config/rofi/colors/solarized.rasi"' > $HOME/.config/rofi/powermenu/type-2/shared/colors.rasi
        echo '@import "~/.config/rofi/colors/solarized.rasi"' > $HOME/.config/rofi/launchers/type-2/shared/colors.rasi
        echo '@import "~/.config/rofi/colors/solarized.rasi"' > $HOME/.config/rofi/applets/shared/colors.rasi
        echo 'type="$HOME/.config/rofi/applets/type-2"' > $HOME/.config/rofi/applets/shared/theme.bash
        echo "style='style-1.rasi'" >> $HOME/.config/rofi/applets/shared/theme.bash
      fi
    '';

  };
}
