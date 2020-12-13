{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    xmrig
  ];
}
