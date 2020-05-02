{ config, ... }:

{
  imports = [
    ./home.nix
  ];

  home.activation = {
    rofi = ''
         cd ${config.resources.pcs.paths.home}/.config/rofi
         for d in bin scripts themes launchers config.rasi; do
           if [[ ! -L "$d" ]]; then
              ln -s ${config.resources.pcs.paths.publicConfig}/vendor/rofi/$d $d
           fi
         done
         if [[ ! -L "pywal.rasi" ]]; then
           ln -s ${config.resources.pcs.paths.home}/.cache/wal/colors-rofi-dark.rasi pywal.rasi
         fi
    '';

    polybar = ''
         cd ${config.resources.pcs.paths.home}/.config/polybar
         for d in pulseaudio-control.bash; do
           if [[ ! -L "$d" ]]; then
              ln -s ${config.resources.pcs.paths.publicConfig}/vendor/polybar-pulseaudio-control/$d $d
           fi
         done
    '';

    folders = ''
         mkdir -p ${config.resources.pcs.paths.home}/src/github.com/${config.resources.services.git.username}
         mkdir -p ${config.resources.pcs.paths.home}/Screenshots/
    '';
  };
}
