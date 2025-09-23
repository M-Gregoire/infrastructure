{ config, lib, pkgs, ... }: {

  programs.aerospace = {
    enable = true;
    # TODO :Not in 25.05. Use when available
    # launchd.enable = true;
  };

  home.packages = [ pkgs.aerospace ];

  home.file.".aerospace.toml".source = ./aerospace/config.toml;
}
