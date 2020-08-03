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
    version = "2.4";
    doCheck = false;
    src = pkgs.python36.pkgs.fetchPypi {
      inherit pname version;
      sha256 = "0w2spm3y9zx5cxarn5ynk8kyxxn8lnv48rs854qvvf650vrxxvpk";
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
      # General use
      virtualenv
      # Polybar spotify controls
      dbus-python
      pygobject3
      # Preview base16 colorschemes
      base16-shell-preview-current
      # Pywall for Firefox
      pywalfox
    ]))
    # pipenv
    pipenv
  ];
}
