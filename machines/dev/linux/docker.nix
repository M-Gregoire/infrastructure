{ pkgs, lib, ... }:

{
  virtualisation.docker = {
    enable = true;
    package = if pkgs ? docker_28 then pkgs.docker_28 else pkgs.docker;
    logDriver = "json-file";
    extraOptions = "--log-opt max-size=10 --log-opt max-file=3";
  };
  environment.systemPackages = with pkgs; [ docker-compose ];
}
