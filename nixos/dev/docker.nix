{ pkgs, ... }:

{
  virtualisation.docker = {
    enable = true;
    logDriver = "json-file";
    extraOptions = "--log-opt max-size=10 --log-opt max-file=3";
  };
  environment.systemPackages = with pkgs; [ docker_compose ];
}
