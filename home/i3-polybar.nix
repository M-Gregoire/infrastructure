{ config, pkgs, lib, ... }:

{
  # Required for network module
  home.packages = with pkgs; [ ethtool ];
  services.polybar = {
    enable = true;
    package = pkgs.polybar.override {
      i3GapsSupport = true;
      pulseSupport = true;
    };
    config = {
      "settings" = {
        screenchange-reload = "true";
      };

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
        font-0 = "${config.resources.font.name}:pixelsize=${config.resources.font.size}:antialias=true;2";
        modules-left = "i3";
        modules-center = "spotify previous playpause next sep date";
        modules-right = "vpn screenshot temperature cpu memory network-wired network-wireless pulseaudio backlight battery powermenu";
        tray-position = "right";
        tray-detached = "false";
        tray-padding = "2";
        tray-background = "\${xrdb:color0}";
        wm-restack = "i3";
        cursor-click = "pointer";
        cursor-scroll = "ns-resize";
        # IPC for Spotify
        enable-ipc = "true";
      };

      "module/previous" = {
        type = "custom/script";
        interval = "86400";
        format = "%{T3}<label>";
        # Previous song icon
        exec = "echo ";
        click-left = "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous";
      };

      "module/next" = {
        type = "custom/script";
        interval = "86400";
        format = "%{T3}<label>";
        # Next song icon
        exec = "echo ";
        click-left = "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next";
      };

      "module/playpause" = {
        type = "custom/ipc";
        # Default
        hook-0 = "echo ";
        # Playing
        hook-1 = "echo ";
        # Paused
        hook-2 = "echo ";
        initial = "1";
        click-left = "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause";
      };

      "module/spotify" = {
        type = "custom/ipc";
        hook-0 = "echo ";
        hook-1 = "python3 ${config.resources.paths.publicConfig}/vendor/polybar-spotify-controls/scripts/spotify/spotify_status.py";
        initial = "1";
        format-padding = "2";
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
        ws-icon-9= "10;%{F#1DD05D}♫ %{F-}";
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

      "module/screenshot" = {
        type = "custom/text";
        content = "";
        click-left = "~/.config/rofi/scripts/menu_screenshot.sh";
      };

      "module/sep" = {
        type = "custom/text";
        content = " | ";
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

      "module/powermenu" = {
        type = "custom/text";
        content = "";
        click-left = "~/.config/rofi/scripts/menu_powermenu.sh";
      };

      "module/vpn" = {
        type = "custom/script";
        exec = "echo ";
        exec-if = "systemctl is-active --quiet wireguard-wg0";
        interval = 5;
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

      "module/pulseaudio" = {
        type = "custom/script";
        tail = "true";
        label = "%output%";

        exec = "~/.config/polybar/pulseaudio-control.bash listen";
        click-right = "exec pavucontrol &";
        click-left = "~/.config/polybar/pulseaudio-control.bash togmute";
        click-middle = "~/.config/polybar/pulseaudio-control.bash next-sink";
        scroll-up = "~/.config/polybar/pulseaudio-control.bash up";
        scroll-down = "~/.config/polybar/pulseaudio-control.bash down";
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
