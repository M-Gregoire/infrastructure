{ pkgs, ... }:

{
  services.polybar.config."module/battery" = {
    adapter = "ADP0";
    animation-charging-0 = "󰢟";
    animation-charging-1 = "󱊤";
    animation-charging-2 = "󱊥";
    animation-charging-3 = "󱊦";
    # animation-charging-4 = "";
    # animation-charging-5 = "";
    # animation-charging-6 = "";
    animation-charging-foreground = "#D1A375";
    animation-charging-framerate = "1000";
    animation-discharging-0 = "󱊣";
    animation-discharging-1 = "󱊢";
    animation-discharging-2 = "󱊡";
    animation-discharging-3 = "󰂎";
    # animation-discharging-4 = "";
    # animation-discharging-5 = "";
    # animation-discharging-6 = "";
    # animation-discharging-7 = "";
    # animation-discharging-8 = "";
    # animation-discharging-9 = "";
    animation-discharging-foreground = "#D1A375";
    animation-discharging-framerate = "500";
    battery = "BAT0";
    format-charging = "<animation-charging>-<label-charging>";
    format-discharging = "<animation-discharging>-<label-discharging>";
    format-full-prefix = "󱊦 -";
    format-full-prefix-foreground = "#D1A375";
    full-at = "100";
    label-charging = "%percentage%%";
    label-charging-foreground = "#C37561";
    label-discharging = "%percentage%%";
    label-discharging-foreground = "#C37561";
    label-full = "%percentage%%";
    label-full-foreground = "#C37561";
    type = "internal/battery";
    poll-interval = 5;
  };

  services.polybar.config."module/network-wireless" = {
    type = "internal/network";
    interface = "wlp58s0";
    interval = "5.0";
    format-connected = "<ramp-signal>";
    format-disconnected = "<label-disconnected>";
    #label-connected = "󰖩";
    label-disconnected = "󰤮";
    ramp-signal-0 = "󰤯";
    ramp-signal-1 = "󰤟";
    ramp-signal-2 = "󰤢";
    ramp-signal-3 = "󰤥";
    ramp-signal-4 = "󰤨";
  };
}
