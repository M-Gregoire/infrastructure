{ config, pkgs, options, ... }:

{
  imports = [
    <home-manager/nixos>
    ../../../modules
    ../../dev/android.nix
    ../../dev/fwudp.nix
    ../../dev/ledger.nix
    ../../dev/pam.nix
    ../../dev/wireguard-tools.nix
    ./services.nix
    ../../systemd-networkd.nix
    ../../../vendor/infrastructure-private/resources/profiles/PC/aliases.nix
  ];

  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;

  # Wifi
  environment.etc."wpa_supplicant.conf".source = "${config.resources.paths.secrets}/wpa_supplicant.conf";

  nix.nixPath = with builtins; options.nix.nixPath.default ++ [
    "nixos-config=${toPath "${config.resources.paths.publicConfig}/nixos/hosts/${config.resources.hostname}/configuration.nix"}"
  ];

  services.xserver.libinput = {
    # Enable libinput
    enable = true;
  };

  programs = {
    zsh = {
      # Fix Tramp (Emacs) with ZSH https://www.emacswiki.org/emacs/TrampMode#toc9
      interactiveShellInit = ''
        [[ $TERM == 'dumb' ]] && unsetopt zle && PS1='$ ' && return
        ${config.resources.paths.scripts}/showTodo.sh
        # https://github.com/gopasspw/gopass/issues/585#issuecomment-355339632
        source <(gopass completion zsh | head -n -1 | tail -n +2)
        compdef _gopass gopass
      '';
    };
  };

  services.xserver.desktopManager.session = [
    {
    name = "home-manager";
    start = ''
      ${pkgs.runtimeShell} $HOME/.hm-xsession &
      waitPID=$!
    '';
    }
  ];

  # Move garbage collection for 3:15 to 14:00
  nix.gc.dates = "14:00";

  users.extraGroups.plugdev = { };
  users.users.${config.resources.username} = {
    extraGroups = [
      # go-mtfs nhoston-root mounting
      "plugdev"
      # Serial
      "dialout"
      # Disk
      "disk"
      # Audio
      "audio"
    ];
  };

  networking.hosts = {
    "${config.resources.hosts.eldir.ip}" = [ "Eldir" "Eldir.${config.resources.domain}"];
  };

  home-manager.users.${config.resources.username} = {...}: {
    imports = [
      ../../../home
      (../../../home/hosts + builtins.toPath "/${config.resources.hostname}")
    ];
    # Pass to home-manager
    nixpkgs.overlays = config.nixpkgs.overlays;
    nixpkgs.config = import ../../../nixpkgs/config.nix;
    resources = config.resources;
  };

  fonts.fonts = with pkgs; [
    # https://github.com/NixOS/nixpkgs/issues/47921#issuecomment-435310057
    # nix-prefetch-url --type sha256 --unpack --name source https://files.martinache.net/nerd-fonts-2.1.0.tar.gz 1la79y16k9rwcl2zsxk73c0kgdms2ma43kpjfqnq5jlbfdj0niwg
    nerdfonts
  ];

  environment.systemPackages = with pkgs; [
    # Grub theming
    # https://askubuntu.com/questions/206967/why-isnt-grub2-using-custom-resolution
    hwinfo
    # NTFS
    ntfs3g
    # exFat
    exfat
  ];

  # We need to copy the theme as root is encrypted
  system.activationScripts = {
    grub = {
      text = ''
        if [ -d "/boot/grub" ]; then
          mkdir -p /boot/grub/themes/Vimix
          cp -R ${config.resources.paths.publicConfig}/vendor/grub2-themes/common/* /boot/grub/themes/Vimix/
          cp -R ${config.resources.paths.publicConfig}/vendor/grub2-themes/config/theme-1080p.txt /boot/grub/themes/Vimix/theme.txt
          cp -R ${config.resources.paths.publicConfig}/vendor/grub2-themes/assets/assets-color/icons-1080p /boot/grub/themes/Vimix/icons
          cp -R ${config.resources.paths.publicConfig}/vendor/grub2-themes/assets/assets-color/select-1080p/*.png /boot/grub/themes/Vimix
          #cp -R ${config.resources.paths.publicConfig}/vendor/infrastructure-private/images/grub-backgrounds/background-mimir.png /boot/grub/themes/Vimix/background.png
          #${pkgs.gnused}/bin/sed -i 's/desktop-image: "background.jpg"/desktop-image: "background.png"/g' /boot/grub/themes/Vimix/theme.txt
        fi
      '';
      deps = [];
    };
  };

  # Get available resolutions using `videoinfo` in grub shell

  #boot.loader.grub.gfxmodeBios = "1920x1440,1280x1024,1024x768,auto";
  #boot.loader.grub.gfxmodeEfi = "1920x1440,1280x1024,1024x768,auto";
  #boot.loader.grub.gfxpayloadBios = "keep";
  #boot.loader.grub.gfxpayloadEfi = "keep";

  # Use grub theme
  # convert background.png -resize 1024x768! -depth 32 background-mimir.png
  #       set theme="($drive1)//grub/themes/Vimix/theme.txt"

  #boot.loader.grub = {
  #  extraConfig = ''
  #    set gfxmode=1920x1440,1280x1024,1024x768,auto
  #    set gfxpayload=keep
  #  '';
  #  splashImage = null;
  #};
  # https://github.com/NixOS/nixpkgs/issues/26722
  boot.plymouth.enable = true;
}
