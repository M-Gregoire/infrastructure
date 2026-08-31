{
  config,
  pkgs,
  flake-root,
  ...
}:

let
  rofiConfig = pkgs.runCommand "rofi-config" { } ''
    cp -R ${flake-root}/vendor/rofi/files "$out"
    chmod -R u+w "$out"

    printf '%s\n' '@import "~/.config/rofi/colors/solarized.rasi"' \
      > "$out/powermenu/type-2/shared/colors.rasi"
    printf '%s\n' '@import "~/.config/rofi/colors/solarized.rasi"' \
      > "$out/launchers/type-2/shared/colors.rasi"
    printf '%s\n' '@import "~/.config/rofi/colors/solarized.rasi"' \
      > "$out/applets/shared/colors.rasi"
    printf '%s\n' 'type="$HOME/.config/rofi/applets/type-2"' "style='style-1.rasi'" \
      > "$out/applets/shared/theme.bash"

    # Preserve the previous pywal.rasi entry point without needing a mutable
    # symlink inside ~/.config/rofi.
    printf '%s\n' '@import "~/.cache/wal/colors-rofi-dark.rasi"' \
      > "$out/pywal.rasi"
  '';
in
{
  # The old activation script created ~/.config/rofi as a mutable directory.
  # Back it up once so Home Manager can replace it with a managed symlink.
  home.activation.cleanupMutableRofiConfig = config.lib.dag.entryBefore [ "checkLinkTargets" ] ''
    if [ -e "$HOME/.config/rofi" ] && [ ! -L "$HOME/.config/rofi" ]; then
      backup="$HOME/.config/rofi.pre-nix-store.$(date +%Y%m%d%H%M%S)"
      echo "Moving existing mutable rofi config to $backup"
      $DRY_RUN_CMD mv "$HOME/.config/rofi" "$backup"
    fi
  '';

  xdg.configFile."rofi".source = rofiConfig;
}
