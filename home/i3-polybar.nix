{ config, pkgs, lib, ... }:

{
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

      "colors" = {
        background = "\${xrdb:color0:#222}";
        foreground = "\${xrdb:color7:#222}";
        foreground-alt = "\${xrdb:color7:#222}";
        primary = "\${xrdb:color1:#222}";
        secondary = "\${xrdb:color2:#222}";
        alert = "\${xrdb:color3:#222}";
      };

      "bar/top-main" = {
        width = "100%";
        height = "20";
        fixed-center = "false";
        background = "\${xrdb:color0:#222}";
        foreground = "\${xrdb:color7:#222}";
        line-size = "3";
        line-color = "#f00";
        padding-left = "1";
        padding-right = "1";
        module-margin-left = "1";
        module-margin-right = "1";
        font-0 = "${config.resources.font.name}:pixelsize=${config.resources.font.size}:antialias=true;2";
        modules-left = "i3";
        modules-center = "spotify previous playpause next";
        modules-right = "pulseaudio temperature memory filesystem xkeyboard battery vpn date sysmenu";
        tray-position = "right";
        tray-detached = "false";
        tray-padding = "2";
        tray-transparent = "false";
        tray-background = "\${xrdb:color0:#222}";
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
        format-padding = "3";
        # Previous song icon
        exec = "echo ";
        format-underline = "#1db954";
        line-size = "1";
        click-left = "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous";
      };

      "module/next" = {
        type = "custom/script";
        interval = "86400";
        format = "%{T3}<label>";
        format-padding = "3";
        # Next song icon
        exec = "echo ";
        format-underline = "#1db954";
        line-size = "1";
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
        format-underline = "#1db954";
        line-size = "1";
        click-left = "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause";
      };

      "module/spotify" = {
        type = "custom/ipc";
        hook-0 = "echo ";
        hook-1 = "python3 ${config.resources.pcs.paths.scripts}/polybar-spotify-controls/scripts/spotify/spotify_status.py";
        initial = "1";
        format-padding = "4";
        format-underline = "#1db954";
        line-size = "1";
      };

      "module/xkeyboard" = {
        type = "internal/xkeyboard";
        blacklist-0 = "num lock";
        format = "<label-layout>";
        format-prefix = "-";
        format-prefix-foreground = "#98B9B1";
        label-layout = "%layout%";
        label-layout-foreground = "#7985A3";
        label-indicator-padding = "2";
        label-indicator-margin = "1";
      };

      "module/filesystem" = {
        type = "internal/fs";
        interval = "25";
        mount-0 = "/";
        format-mounted = "<label-mounted>";
        format-unmounted = "<label-unmounted>";
        format-unmounted-prefix = "-";
        format-unmounted-prefix-foreground = "#E6E6E6";
        format-mounted-prefix = "-";
        format-mounted-prefix-foreground = "#E6E6E6";
        label-mounted = "%percentage_used%%";
        label-mounted-foreground = "#E6E6E6";
        label-unmounted = "unmounted";
        label-unmounted-foreground = "#E6E6E6";
      };

      "module/i3" = {
        type = "internal/i3";
        index-sort = "true";
        wrapping-scroll = "false";
        ws-icon-0 = "1;";
        ws-icon-1 = "2;";
        ws-icon-2 = "3;";
        ws-icon-3 = "4;";
        ws-icon-4 = "5;";
        ws-icon-5 = "6;";
        ws-icon-6 = "7;";
        ws-icon-7 = "8;";
        ws-icon-8 = "9;";
        ws-icon-9= "10;♫";
        ws-icon-default = "";
        format = "<label-state>";
        label-focused = "%icon%";
        label-focused-foreground = "#7985A3";
        label-focused-padding = "2";
        label-unfocused = "%icon%";
        label-unfocused-padding = "2";
        label-visible = "%icon%";
        label-visible-padding = "2";
        label-urgent = "%icon%";
        label-urgent-foreground = "#C37561";
        label-urgent-padding = "2";
      };

      "module/cpu" = {
        type = "internal/cpu";
        interval = "1";
        format-prefix = "龍-";
        format-prefix-foreground = "#A0A57E";
        label = "%percentage%%";
        label-foreground = "#98B9B1";
      };

      "module/memory" = {
        type = "internal/memory";
        interval = "1";
        format-prefix = "-";
        format-prefix-foreground = "#A0A57E";
        label = "%percentage_used%%";
        label-foreground = "#98B9B1";
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
        date = "%d/%m/%y";
        time = "%H:%M";
        label = " %date%  %time%";
      };

      "module/pulseaudio" = {
        type = "internal/pulseaudio";
        format-volume-prefix = "墳-";
        format-volume-prefix-foreground = "#AB716D";
        format-volume = "<label-volume>";
        label-volume = "%percentage%%";
        label-volume-foreground = "#D1A375";
        format-muted-prefix = "婢-";
        format-muted-prefix-foreground = "#AB716D";
        format-muted = "<label-muted>";
        label-muted = "muted";
        label-muted-foreground = "#D1A375";
        bar-volume-width = "10";
        bar-volume-foreground-0 = "#B6B99D";
        bar-volume-foreground-1 = "#A0A57E";
        bar-volume-foreground-2 = "#DEBC9C";
        bar-volume-foreground-3 = "#D1A375";
        bar-volume-foreground-4 = "#D19485";
        bar-volume-foreground-5 = "#C36561";
        bar-volume-gradient = "false";
        bar-volume-indicator = "┃";
        bar-volume-indicator-font = "2";
        bar-volume-fill = "━";
        bar-volume-fill-font = "2";
        bar-volume-empty = "╍";
        bar-volume-empty-font = "2";
        bar-volume-empty-foreground = "#E6E6E6";
      };

      "module/temperature" = {
        type = "internal/temperature";
        thermal-zone = "0";
        warn-temperature = "80";
        format = "<ramp> <label>";
        format-warn = "<ramp> <label-warn>";
        label = "%temperature-c%";
        label-warn = "%temperature-c%";
        label-warn-foreground = "#C37561";
        units = "true";
        ramp-0 = "";
        ramp-1 = "";
        ramp-2 = "";
        ramp-3 = "";
        ramp-4 = "";
        ramp-foreground = "#f5f5f5";
      };

      "global/wm" = {
        margin-top = "5";
        margin-bottom = "5";
      };
    };
    script = "";
  };
}
