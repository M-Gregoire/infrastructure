{ config, pkgs, lib, user, hostname, cluster, clusterRole, profile, network
, inputs, ... }:

{

  config = {
    nix.settings = {
      experimental-features = [ "nix-command" "flakes" ];
      substituters = [ "https://nix-cache.martinache.net/hades" ];
      trusted-public-keys = [ "hades:pWcHX3vzVabOBcdgMn+oesgqYxKvda27XQrRicRzK/0=" ];
      # Fail fast when attic cache is unavailable instead of blocking builds
      connect-timeout = 5;
      fallback = true;
    };

    nix.extraOptions = ''
      post-build-hook = ${pkgs.writeShellScript "attic-push-hook" ''
        set -eu
        set -f
        TOKEN_FILE="/etc/attic/token"
        LOCKFILE="/tmp/attic-push-unavailable"

        # Skip if server was recently unavailable (5 min cooldown)
        if [ -f "$LOCKFILE" ] && ${pkgs.findutils}/bin/find "$LOCKFILE" -mmin -5 2>/dev/null | ${pkgs.gnugrep}/bin/grep -q .; then
          exit 0
        fi

        if [ -f "$TOKEN_FILE" ]; then
          # Quick connectivity check (3s timeout)
          if ! ${pkgs.curl}/bin/curl -sf --connect-timeout 3 --max-time 5 "https://nix-cache.martinache.net/" >/dev/null 2>&1; then
            echo "warning: attic cache unavailable, skipping push for 5 minutes" >&2
            touch "$LOCKFILE"
            exit 0
          fi
          rm -f "$LOCKFILE"

          CONFIG_DIR=$(mktemp -d)
          trap 'rm -rf "$CONFIG_DIR"' EXIT
          mkdir -p "$CONFIG_DIR/attic"
          ATTIC_TOKEN=$(cat "$TOKEN_FILE")
          {
            echo 'default-server = "hades"'
            echo ""
            echo '[servers.hades]'
            echo 'endpoint = "https://nix-cache.martinache.net"'
            echo "token = \"$ATTIC_TOKEN\""
          } > "$CONFIG_DIR/attic/config.toml"
          ${pkgs.coreutils}/bin/timeout 30 ${pkgs.attic-client}/bin/attic push hades $OUT_PATHS 2>/dev/null || {
            echo "warning: attic push failed or timed out, skipping push for 5 minutes" >&2
            touch "$LOCKFILE"
          }
        fi
      ''}
    '';
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
            command nix --access-tokens "github.com/M-Gregoire=$GITHUB_TOKEN" "$@"
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
