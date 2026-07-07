{ pkgs, ... }:

{
  home.packages = with pkgs;
    [
      pywalfox-native
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
        ]))
    ];
}
