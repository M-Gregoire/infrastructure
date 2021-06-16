{ pkgs, ... }:

let

  base16-shell-preview-current = pkgs.python36.pkgs.buildPythonPackage rec {
    pname = "base16_shell_preview";
    version = "0.6.3";
    doCheck = false;
    src = pkgs.python36.pkgs.fetchPypi {
      inherit pname version;
      sha256 = "0kdwil0w151yih94s75z742rcaf1mj3w17w6ydr61ylhnds7dpfp";
    };
  };

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
    (python2.withPackages (ps: with ps; [
      # General use
      virtualenv
    ]))

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
