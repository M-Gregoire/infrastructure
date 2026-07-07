{ config, pkgs, lib, user, hostname, cluster, clusterRole, profile, network
, inputs, ... }:

{

  config = {
    nix.settings = {
      experimental-features = [ "nix-command" "flakes" ];
    };
    environment.systemPackages = with pkgs; [
      # File type
      file
      # DNS utils (dig)
      dnsutils
      # htop
      htop
      # tmux
      tmux
      # tree
      tree
      # dhclient
      # dhcp
      # lsof
      lsof
      vim
      coreutils
    ];

    users.groups.${user} = {
      name = user;
      members = [ user ];
      gid = 1000;
    };

    programs.zsh = {
      enable = true;

      interactiveShellInit = ''
                # Only set aliases in interactive shells
                  alias cd='z'
                  alias cat='bat'
                  alias ls='eza'

        # Warn if Bitwarden is not logged in (Linux only, non-blocking)
        if command -v bw >/dev/null 2>&1 && [ "$(hostname)" != "COMP-CQ5H77T0CQ" ]; then
          if ! bw login --check >/dev/null 2>&1; then
            echo "\033[33m⚠ Bitwarden is not logged in — nix commands will fail to authenticate with GitHub.\033[0m"
            echo "  Run: bw config server https://your-vault-url && bw login"
          elif [ -z "$BW_SESSION" ] && ! bw unlock --check >/dev/null 2>&1; then
            echo "\033[33m⚠ Bitwarden vault is locked — nix commands will fail to authenticate with GitHub.\033[0m"
            echo "  Run: export BW_SESSION=\$(bw unlock --raw)"
          fi
        fi

        load-github-token() {
            [ -n "$GITHUB_TOKEN" ] && return

            HOSTNAME=$(hostname)

            if [ "$HOSTNAME" = "COMP-CQ5H77T0CQ" ]; then
                export GITHUB_TOKEN=$(op read "op://Employee/GitHub/add more/nix-token")
            else
                export GITHUB_TOKEN=$(bw get password github-nix-token)
            fi
        }

        # Auto-load token for nix commands
        nix() {
            load-github-token
            command nix --access-tokens "github.com=$GITHUB_TOKEN" "$@"
        }
      '';
    };

    users.users.${user} = {
      home =
        (if pkgs.stdenv.isLinux then "/home/${user}" else "/Users/${user}");
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = config.resources.services.ssh.publicKeys;
    };

    time.timeZone = "Europe/Paris";

    security.pki.certificates = config.resources.pki.acrs;

    nix.gc = { automatic = true; };
  };

}
