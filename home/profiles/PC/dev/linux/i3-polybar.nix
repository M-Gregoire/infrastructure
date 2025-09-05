{ config, pkgs, lib, flake-root, ... }:

{
  # Required for network module
  home.packages = with pkgs; [ ethtool ];
  services.polybar = {
    enable = true;
    package = pkgs.polybar.override {
      i3Support = true;
      pulseSupport = true;
    };
    config = {
      "settings" = { screenchange-reload = "true"; };

      "bar/top-main" = {
        width = "100%";
        height = "20";
        fixed-center = "false";
        background = "\${xrdb:color0}";
        foreground = "\${xrdb:color7}";
        line-size = "1";
        padding-left = "1";
        padding-right = "1";
        module-margin-left = "1";
        module-margin-right = "1";
        font-0 = "${config.resources.font.name}:pixelsize=${
            lib.strings.floatToString config.resources.font.size
          }:antialias=true;2";
        modules-left = "i3";
        modules-center =
          "spotify spotify-prev spotify-play-pause spotify-next sep date";
        # TODO: Add pipewire module
        modules-right =
          "temperature cpu memory network-wired network-wireless battery tray";
        wm-restack = "i3";
        cursor-click = "pointer";
        cursor-scroll = "ns-resize";
        # IPC for Spotify
        enable-ipc = "true";
      };

      "module/spotify-prev" = {
        type = "custom/script";
        # interval = "86400";
        format = "%{T3}<label>";
        # Previous song icon
        exec = "echo ";
        click-left = "playerctl previous -p spotify";
      };

      "module/spotify-next" = {
        type = "custom/script";
        # interval = "86400";
        format = "%{T3}<label>";
        # Next song icon
        exec = "echo ";
        click-left = "playerctl next -p spotify";
      };

      "module/spotify-play-pause" = {
        type = "custom/ipc";
        # Playing
        hook-0 = "echo ";
        # Paused
        hook-1 = "echo ";
        initial = "1";
        click-left = "playerctl play-pause -p spotify";
      };

      "module/spotify" = {
        type = "custom/script";
        tail = true;
        interval = 1;
        format-prefix = " ";
        format = "<label>";
        exec = "${flake-root}/vendor/polybar-spotify/scroll_spotify_status.sh";
        # format-padding = "2";
      };

      "module/i3" = {
        type = "internal/i3";
        index-sort = "true";
        wrapping-scroll = "false";
        ws-icon-0 = "1;%{F#F65F12} %{F-}";
        ws-icon-1 = "2;%{F#3C8642} %{F-}";
        ws-icon-2 = "3; ";
        ws-icon-3 = "4;%{F#1E88E5} %{F-}";
        ws-icon-4 = "5; ";
        ws-icon-5 = "6; ";
        ws-icon-6 = "7; ";
        ws-icon-7 = "8;%{F#D91D57} %{F-}";
        ws-icon-8 = "9;%{F#205FB6} %{F-}";
        ws-icon-9 = "10;%{F#1DD05D}♫ %{F-}";
        ws-icon-default = "";
        format = "<label-state>";
        label-focused = "%icon%";
        label-focused-padding = "2";
        label-focused-underline = "#FFF";
        label-unfocused = "%icon%";
        label-unfocused-padding = "2";
        label-visible = "%icon%";
        label-visible-padding = "2";
        label-urgent = "%icon%";
        label-urgent-background = "#C37561";
        label-urgent-padding = "2";
      };

      "module/cpu" = {
        type = "internal/cpu";
        interval = "1";
        format = "<label> <ramp-load>";
        label = "";
        label-foreground = "#98B9B1";
        ramp-load-0 = "▁";
        ramp-load-1 = "▂";
        ramp-load-2 = "▃";
        ramp-load-3 = "▄";
        ramp-load-4 = "▅";
        ramp-load-5 = "▆";
        ramp-load-6 = "▇";
        ramp-load-7 = "█";

        ramp-load-0-foreground = "#B6B99D";
        ramp-load-1-foreground = "#B6B99D";
        ramp-load-2-foreground = "#A0A57E";
        ramp-load-3-foreground = "#DEBC9C";
        ramp-load-4-foreground = "#DEBC9C";
        ramp-load-5-foreground = "#D1A375";
        ramp-load-6-foreground = "#D19485";
        ramp-load-7-foreground = "#C36561";
      };

      "module/sep" = {
        type = "custom/text";
        format = " | ";
      };

      "module/memory" = {
        type = "internal/memory";
        interval = "1";

        format = "<label> <ramp-used>";
        label = "";
        label-foreground = "#98B9B1";

        ramp-used-0 = "▁";
        ramp-used-1 = "▂";
        ramp-used-2 = "▃";
        ramp-used-3 = "▄";
        ramp-used-4 = "▅";
        ramp-used-5 = "▆";
        ramp-used-6 = "▇";
        ramp-used-7 = "█";

        ramp-used-0-foreground = "#B6B99D";
        ramp-used-1-foreground = "#B6B99D";
        ramp-used-2-foreground = "#A0A57E";
        ramp-used-3-foreground = "#DEBC9C";
        ramp-used-4-foreground = "#DEBC9C";
        ramp-used-5-foreground = "#D1A375";
        ramp-used-6-foreground = "#D19485";
        ramp-used-7-foreground = "#C36561";
      };

      "module/date" = {
        type = "internal/date";
        interval = "1";
        date = "%A %d %B";
        time = "at %I:%M %p";
        label = "%date% %time%";
        format-prefix = " ";
        format-prefix-foreground = "#AB71FD";
      };

      "module/tray" = {
        type = "internal/tray";
        tray-spacing = "0px";
      };

      "module/temperature" = {
        type = "internal/temperature";
        thermal-zone = "0";
        warn-temperature = "80";

        format = "<ramp> <label>";
        format-warn = "<label-warn>";

        label = "%temperature-c%";
        label-warn = " %temperature-c%";
        label-warn-foreground = "#F00";
        units = "true";

        ramp-0 = "";
        ramp-1 = "";
        ramp-2 = "";
        ramp-3 = "";
        ramp-4 = "";
        ramp-0-foreground = "#B6B99D";
        ramp-1-foreground = "#A0A57E";
        ramp-2-foreground = "#DEBC9C";
        ramp-3-foreground = "#D19485";
        ramp-4-foreground = "#C36561";
      };

      "global/wm" = {
        margin-top = "5";
        margin-bottom = "5";
      };
    };
    script = "";
  };
}
