{ config, lib, pkgs, ... }:
let
  # anylinuxfs dependency
  muslcrossTap = pkgs.fetchFromGitHub {
    owner = "FiloSottile";
    repo = "homebrew-musl-cross";
    rev = "50387b9c39df55c7e08039030b1262bfdb916605";
    sha256 = "sha256-TAi5NCzuX8d4bJirdyazm5zNGw95SHY9IcFduA6JAD0=";
  };
  # anylinuxfs dependency
  krunTap = pkgs.fetchFromGitHub {
    owner = "slp";
    repo = "homebrew-krun";
    rev = "5df38229223b11f63608e4c7e03403cee923abc8";
    sha256 = "sha256-avGDiB6nNQoDzcWbWLqBJrv9hypg5JYzHk8OriC6dYc=";
  };
  anylinuxfsTap = pkgs.fetchFromGitHub {
    owner = "nohajc";
    repo = "homebrew-anylinuxfs";
    rev = "6b90f30cd48e1b3e685dc3ff37448f293a7decfa";
    sha256 = "sha256-LzvdjSW+V3StLfmgkJDO42YbF14ykJj7/WSFnF0UoHg=";
  };
in {

  nix-homebrew = {
    taps = {
      "FiloSottile/homebrew-musl-cross" = muslcrossTap;
      "slp/homebrew-krun" = krunTap;
      "nohajc/homebrew-anylinuxfs" = anylinuxfsTap;
    };
  };

  homebrew = {
    brews = [ "bitwarden-cli" "anylinuxfs" ];
    casks = [ "bitwarden" ];
  };
}
