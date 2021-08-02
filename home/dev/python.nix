{ pkgs, ... }:

let

  pywalfox = pkgs.python36.pkgs.buildPythonPackage rec {
    pname = "pywalfox";
    version = "2.7.3";
    doCheck = false;
    src = pkgs.python36.pkgs.fetchPypi {
      inherit pname version;
      sha256 = "1gkxcnysygvcpfhinaxaa6lf7b7194x7vi928i0qpdw962ck1zsi";
    };
  };

in

{
  home.packages = with pkgs; [
    (python36.withPackages (ps: with ps; [
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
