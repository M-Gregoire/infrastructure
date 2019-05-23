{ pkgs, ... }:

let

  goflymake = pkgs.buildGoPackage rec {
    name = "goflymake";
    goPackagePath = "github.com/dougm/goflymake";

    src = pkgs.fetchFromGitHub {
      owner = "dougm";
      repo = "goflymake";
      rev = "3b9634ef394a5ec125c6847195b1101ec1f47708";
      sha256 = "0fy6frljzwz4y07yk602jiyk0xp83snwdsjmhk7y8akrv18vd9r3";
    };
  };

in

{
  home.packages = with pkgs;[
    go
    # Guru and other tools
    gotools
    # Emacs flymake support
    goflymake
    # Dependencies
    dep
  ];

}
