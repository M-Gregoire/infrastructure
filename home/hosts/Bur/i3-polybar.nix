{ pkgs, ... }:

{
  services.polybar.config."module/battery" = {
    adapter = "ADP0";
    animation-charging-0 = "";
    animation-charging-1 = "";
    animation-charging-2 = "";
    animation-charging-3 = "";
    animation-charging-4 = "";
    animation-charging-5 = "";
    animation-charging-6 = "";
    animation-charging-foreground = "#D1A375";
    animation-charging-framerate = "1000";
    animation-discharging-0 = "";
    animation-discharging-1 = "";
    animation-discharging-10 = "";
    animation-discharging-2 = "";
    animation-discharging-3 = "";
    animation-discharging-4 = "";
    animation-discharging-5 = "";
    animation-discharging-6 = "";
    animation-discharging-7 = "";
    animation-discharging-8 = "";
    animation-discharging-9 = "";
    animation-discharging-foreground = "#D1A375";
    animation-discharging-framerate = "500";
    battery = "BAT0";
    format-charging = "<animation-charging>-<label-charging>";
    format-discharging = "<animation-discharging>-<label-discharging>";
    format-full-prefix = "-";
    format-full-prefix-foreground = "#D1A375";
    full-at = "100";
    label-charging = "%percentage%%";
    label-charging-foreground = "#C37561";
    label-discharging = "%percentage%%";
    label-discharging-foreground = "#C37561";
    label-full = "%percentage%%";
    label-full-foreground = "#C37561";
    type = "internal/battery";
  };
  services.polybar.config."module/backlight" = {
    card = "acpi_video0";
    bar-empty = "┉";
    bar-empty-font = "2";
    bar-fill = "━";
    bar-fill-font = "2";
    bar-gradient = "false";
    bar-indicator = "";
    bar-indicator-font = "2";
    bar-width = "7";
    enable-scroll = "true";
    format = "<ramp> <bar>";
    ramp-foreground = "#B6B99D";
    ramp-0 = "";
    ramp-1 = "";
    ramp-2 = "";
    ramp-3 = "";
    ramp-4 = "";
    ramp-5 = "";
    ramp-6 = "";
    ramp-7 = "";
    ramp-width = "10";
    type = "internal/backlight";
  };
  services.polybar.config."module/network-wireless" = {
    type = "internal/network";
    interface = "wlp1s0";
    interval = "5.0";
    format-connected = "<ramp-signal> <label-connected>";
    format-disconnected = "<label-disconnected>";
    label-connected = "直";
    label-disconnected = "睊";

    ramp-signal-0 = "ﮙ";
    ramp-signal-1 = "";
    ramp-signal-2 = "";
    ramp-signal-3 = "";
    ramp-signal-4 = "";
    ramp-signal-5 = "ﮚ";
    ramp-signal-6 = "";
  };
}
