{ config, lib, pkgs, inputs, user, ... }: {

  environment.systemPackages = with pkgs; [ ansible ];

  homebrew.brews = [ "ripgrep" "aws-vault" "pyenv" "node" "tfenv" "awscli" ];
  homebrew.casks = [
    "datadog/tap/dd-gitsign"
    "datadog/tap/dd-auth"
    "google-cloud-sdk"
    "nikitabobko/tap/aerospace"
    "karabiner-elements"
    "1password-cli"
    "aws-vault"
    "cursor"
  ];

  system.stateVersion = 6;
}
