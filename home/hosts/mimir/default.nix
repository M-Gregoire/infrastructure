{ pkgs, lib, ... }:

{
  imports = [ ./i3-polybar.nix ];

  # Racked streaming server — no local emacs daemon needed
  systemd.user.services.emacs.Install.WantedBy = lib.mkForce [];
}
