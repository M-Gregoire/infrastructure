{ config, lib, pkgs, ... }:

{
  users.users.gregoire.home = "/Users/gregoire";

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  programs.zsh = {
    enable = true;
    shellInit = ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
    '';
  };

  security.pam.enableSudoTouchIdAuth = true;

  services.yabai = {
    enable = true;
    enableScriptingAddition = true;
    config = {
      layout = "bsp";
      mouse_follows_focus = "off";
      window_placement = "second_child";
      window_opacity = "off";
      top_padding = 0;
      bottom_padding = 0;
      left_padding = 0;
      right_padding = 0;
      window_gap = 10;
      window_border_radius = 0;
    };
  };
  services.sketchybar = {
    enable = true;
    config = ''
      PLUGIN_DIR="$CONFIG_DIR/plugins"
      sketchybar --bar position=top height=40 blur_radius=30 color=0x40000000
      default=(
        padding_left=5
        padding_right=5
        icon.font="Hack Nerd Font:Bold:17.0"
        label.font="Hack Nerd Font:Bold:14.0"
        icon.color=0xffffffff
        label.color=0xffffffff
        icon.padding_left=4
        icon.padding_right=4
        label.padding_left=4
        label.padding_right=4
      )
      sketchybar --default "''${default[@]}"

      SPACE_ICONS=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10")
      for i in "''${!SPACE_ICONS[@]}"
      do
        sid="$(($i+1))"
        space=(
          space="$sid"
          icon="''${SPACE_ICONS[i]}"
          icon.padding_left=7
          icon.padding_right=7
          background.color=0x40ffffff
          background.corner_radius=5
          background.height=25
          label.drawing=off
          script="$PLUGIN_DIR/space.sh"
          click_script="yabai -m space --focus $sid"
        )
        sketchybar --add space space."$sid" left --set space."$sid" "''${space[@]}"
      done

      sketchybar --add item chevron left \
           --set chevron icon= label.drawing=off \
           --add item front_app left \
           --set front_app icon.drawing=off script="$PLUGIN_DIR/front_app.sh" \
           --subscribe front_app front_app_switched


      sketchybar --add item clock right \
           --set clock update_freq=10 icon=  script="$PLUGIN_DIR/clock.sh" \
           --add item volume right \
           --set volume script="$PLUGIN_DIR/volume.sh" \
           --subscribe volume volume_change \
           --add item battery right \
           --set battery update_freq=120 script="$PLUGIN_DIR/battery.sh" \
           --subscribe battery system_woke power_source_change

      sketchybar --update
    '';
  };

  services.skhd = {
    enable = true;
    skhdConfig = ''
      cmd - return : /Applications/kitty.app/Contents/MacOS/kitty --single-instance -d ~
      cmd - q : yabai -m window --close
      cmd - f : yabai -m window --toggle zoom-fullscreen
      cmd - up : yabai -m window --focus north
      cmd - down : yabai -m window --focus south
      cmd - right : yabai -m window --focus east
      cmd - left : yabai -m window --focus west
      cmd - 1 : yabai -m space --focus 1
      cmd - 2 : yabai -m space --focus 2
      cmd - 3 : yabai -m space --focus 3
      cmd - 4 : yabai -m space --focus 4
      cmd - 5 : yabai -m space --focus 5
      cmd - 6 : yabai -m space --focus 6
      cmd - 7 : yabai -m space --focus 7
      cmd - 8 : yabai -m space --focus 8
      cmd - 9 : yabai -m space --focus 9
    '';
  };
}
