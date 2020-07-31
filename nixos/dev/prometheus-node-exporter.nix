{ config, ... }:

{
  services.prometheus.exporters.node = {
    enable = true;
    port = 9100;
    openFirewall = true;
  };
}
