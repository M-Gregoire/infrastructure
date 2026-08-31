{
  config,
  pkgs,
  private-config,
  ...
}:

{
  nix.settings = {
    substituters = [ "https://nix-cache.martinache.net/hades" ];
    trusted-public-keys = [ "hades:pWcHX3vzVabOBcdgMn+oesgqYxKvda27XQrRicRzK/0=" ];
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
}
