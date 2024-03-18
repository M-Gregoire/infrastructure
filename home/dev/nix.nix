{ pkgs, ... }:

{
  home.packages = with pkgs; [ nixops_unstable ];
}
