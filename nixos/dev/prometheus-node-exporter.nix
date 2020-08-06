{ config, ... }:

{
  services.prometheus.exporters.node = {
    enable = true;
    port = 9100;
    openFirewall = true;
  };
  # Allow access only via docker interface
  networking.firewall.interfaces = {
    "docker0" = { allowedTCPPorts = [ 9100 ]; };
  };
}
