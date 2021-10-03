{ pkgs, ... }:

let

  pywalfox = pkgs.python36.pkgs.buildPythonPackage rec {
    pname = "pywalfox";
    version = "2.7.4";
    doCheck = false;
    src = pkgs.python36.pkgs.fetchPypi {
      inherit pname version;
      sha256 = "0rpdh1k4b37n0gcclr980vz9pw3ihhyy0d0nh3xp959q4xz3vrsr";
    };
  };

in {
  home.packages = with pkgs;
    [
      (python36.withPackages (ps:
        with ps; [
          # Virtualenv
          pip
          virtualenv
          # Polybar spotify controls
          dbus-python
          pygobject3
          # Pywall for Firefox
          pywalfox
        ]))
    ];
}
