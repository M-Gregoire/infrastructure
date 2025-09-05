{ pkgs, ... }:

let

  pywalfox = pkgs.python314.pkgs.buildPythonPackage {
    pname = "pywalfox";
    version = "2.8.0rc1";

    src = pkgs.fetchFromGitHub {
      owner = "Frewacom";
      repo = "pywalfox-native";
      rev = "7ecbbb193e6a7dab424bf3128adfa7e2d0fa6ff9";
      hash = "sha256-i1DgdYmNVvG+mZiFiBmVHsQnFvfDFOFTGf0GEy81lpE=";
    };
  };
in {
  home.packages = with pkgs;
    [
      # TODO: Restore python packages
      (python314.withPackages (ps:
        with ps;
        [
          # Virtualenv
          # pip
          # virtualenv
          # Polybar spotify controls
          # dbus-python
          # pygobject3
          # Pywall for Firefox
          # pywalfox
        ]))
    ];
}
