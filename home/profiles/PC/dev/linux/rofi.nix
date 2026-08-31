{
  config,
  pkgs,
  ...
}:

let
  rofiThemes = pkgs.fetchFromGitHub {
    owner = "adi1090x";
    repo = "rofi";
    # Base commit of the old M-Gregoire/rofi fork. Local customizations from
    # b65d3f5d54652e5afe527d45e78635839878934d are applied below instead of
    # keeping a fork/submodule.
    rev = "45241fd31313e7f3653e9e0bfdb837b45ed3e17c";
    hash = "sha256-G3sAyIZbq1sOJxf+NBlXMOtTMiBCn6Sat8PHryxRS0w=";
  };

  confirmRasi = pkgs.writeText "rofi-confirm.rasi" ''
    /**
     *
     * Author : Aditya Shakya (adi1090x)
     * Github : @adi1090x
     *
     * Rofi Theme File
     * Rofi Version: 1.7.3
     **/

    /*****----- Configuration -----*****/
    configuration {
        show-icons:                 false;
    }

    /*****----- Global Properties -----*****/
    @import                          "colors.rasi"
    @import                          "fonts.rasi"

    /*****----- Main Window -----*****/
    window {
        location:                    center;
        anchor:                      center;
        fullscreen:                  false;
        width:                       500px;
        border-radius:               20px;
        cursor:                      "default";
        background-color:            @background;
    }

    /*****----- Main Box -----*****/
    mainbox {
        spacing:                     30px;
        padding:                     30px;
        background-color:            transparent;
        children:                    [ "message", "listview" ];
    }

    /*****----- Message -----*****/
    message {
        margin:                      0px;
        padding:                     20px;
        border-radius:               20px;
        background-color:            @background-alt;
        text-color:                  @foreground;
    }
    textbox {
        background-color:            inherit;
        text-color:                  inherit;
        vertical-align:              0.5;
        horizontal-align:            0.5;
        placeholder-color:           @foreground;
        blink:                       true;
        markup:                      true;
    }

    /*****----- Listview -----*****/
    listview {
        columns:                     2;
        lines:                       1;
        cycle:                       true;
        dynamic:                     true;
        scrollbar:                   false;
        layout:                      vertical;
        reverse:                     false;
        fixed-height:                true;
        fixed-columns:               true;

        spacing:                     30px;
        background-color:            transparent;
        text-color:                  @foreground;
        cursor:                      "default";
    }

    /*****----- Elements -----*****/
    element {
        padding:                     60px 10px;
        border-radius:               20px;
        background-color:            @background-alt;
        text-color:                  @foreground;
        cursor:                      pointer;
    }
    element-text {
        font:                        "feather 48";
        background-color:            transparent;
        text-color:                  inherit;
        cursor:                      inherit;
        vertical-align:              0.5;
        horizontal-align:            0.5;
    }
    element selected.normal {
        background-color:            var(selected);
        text-color:                  var(background);
    }
  '';

  rofiConfig = pkgs.runCommand "rofi-config" { } ''
    cp -R ${rofiThemes}/files "$out"
    chmod -R u+w "$out"

    # Local customizations formerly carried by M-Gregoire/rofi@b65d3f5.
    printf '%s\n' '@import "~/.config/rofi/colors/solarized.rasi"' \
      > "$out/powermenu/type-2/shared/colors.rasi"
    printf '%s\n' '@import "~/.config/rofi/colors/solarized.rasi"' \
      > "$out/launchers/type-2/shared/colors.rasi"
    printf '%s\n' '@import "~/.config/rofi/colors/solarized.rasi"' \
      > "$out/applets/shared/colors.rasi"
    printf '%s\n' 'type="$HOME/.config/rofi/applets/type-2"' "style='style-1.rasi'" \
      > "$out/applets/shared/theme.bash"

    ${pkgs.gnused}/bin/sed -i "s/theme='style-10'/theme='style-11'/" \
      "$out/launchers/type-3/launcher.sh"
    ${pkgs.gnused}/bin/sed -i "s/theme='style-1'/theme='style-3'/" \
      "$out/powermenu/type-3/powermenu.sh"
    ${pkgs.gnused}/bin/sed -i "s/theme='style-5'/theme='style-2'/" \
      "$out/powermenu/type-4/powermenu.sh"
    cp ${confirmRasi} "$out/powermenu/type-2/shared/confirm.rasi"

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
