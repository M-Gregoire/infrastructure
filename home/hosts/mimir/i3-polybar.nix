{ pkgs, ... }:

{
  services.polybar.config."module/network-wired" = {
    type = "internal/network";
    interface = "enp6s0";
    interval = "5.0";
    format-connected = "<label-connected>";
    format-disconnected = "<label-disconnected>";
    label-connected = "";
    label-disconnected = "";
  };
}
