{ config, lib, pkgs, inputs, user, ... }: {

  homebrew.casks = [ "datadog/tap/tfdeployctl" ];

  system.stateVersion = 6;
}
