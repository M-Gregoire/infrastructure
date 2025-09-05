{ pkgs, config, ... }:

{
  # disabledModules = [ "services/desktops/pipewire/pipewire.nix" ];
  # imports = [ # Use service from nixos-unstable channel.
  #   # sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable
  #   <nixos-unstable/nixos/modules/services/desktops/pipewire/pipewire.nix>
  # ];

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };
}
