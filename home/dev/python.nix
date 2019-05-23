{ pkgs, ... }:

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
    ]))
    # pipenv
    pipenv
  ];
}
