{ pkgs, config, user, ... }:

{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    # Proton-GE: community-patched Proton with broader Windows game compatibility
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  # Boosts CPU governor and applies other optimisations while a game is running
  programs.gamemode.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
  };

  # Required by many modern games (Elden Ring, CS2, Star Citizen, etc.)
  boot.kernel.sysctl."vm.max_map_count" = 1048576;

  # steam-run: run arbitrary Steam-runtime binaries outside Steam
  # mangohud: in-game performance overlay (FPS, frametime, GPU/CPU usage)
  environment.systemPackages = with pkgs; [ steam-run mangohud ];
}
