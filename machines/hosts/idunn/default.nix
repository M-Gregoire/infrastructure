{ config, lib, pkgs, inputs, user, ... }:

let
  cephTap = builtins.fetchGit {
    url = "https://github.com/mulbc/homebrew-ceph-client";
    rev = "5243db315d7541bd7e190dbc66d1237b2c815f68";
  };
  # linux-builder-vz is in nixos-unstable (landing in 26.11), not yet in 26.05
  pkgs-unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
  imports = [ ../../dev/attic.nix ];
  nix-homebrew = { taps = { "mulbc/homebrew-ceph-client" = cephTap; }; };
  homebrew.brews =
    [ "ceph-client" "openssh" "openvpn" "docker" "python3" "esphome" "pipx" ];
  homebrew.casks = [
    "openvpn-connect"
    "firefox"
    "thunderbird"
    "signal"
    "bitwarden"
    "calibre"
    "libreoffice"
    "multipass"
    "android-platform-tools"
  ];

  users.groups.nfs_access = {
    members = [ "${user}" ];
    gid = 1000;
  };

  # Linux builder VM using Apple Virtualization.framework (VZ) backend.
  # Supports both aarch64-linux (native) and x86_64-linux (via Rosetta 2).
  # linux-builder-vz from nixpkgs-unstable until it lands in stable (26.11).
  nix.linux-builder = {
    enable = true;
    package = pkgs-unstable.darwin.linux-builder-vz;
    systems = [ "aarch64-linux" "x86_64-linux" ];
    config = {
      virtualisation = {
        cores = 8;
        memorySize = lib.mkForce 8192;
        diskSize = lib.mkForce (60 * 1024);
      };
      networking.nameservers = [ "192.168.3.1" ];
      # NTP — prevent clock drift that breaks TLS verification
      services.timesyncd.enable = lib.mkForce true;
      # Trust the private root CA for nix-cache.martinache.net
      security.pki.certificates = config.resources.pki.acrs;
      nix.settings = {
        always-allow-substitutes = true;
        extra-substituters = [ "https://nix-cache.martinache.net/hades" ];
        extra-trusted-public-keys = [ "hades:pWcHX3vzVabOBcdgMn+oesgqYxKvda27XQrRicRzK/0=" ];
      };
      # Auto-GC when disk runs low — builds are pushed to attic anyway
      nix.gc = {
        automatic = true;
        dates = "hourly";
        options = "--delete-older-than 1d";
      };
      # GC when free space drops below 10GB during builds
      nix.settings.min-free = lib.mkForce (10 * 1024 * 1024 * 1024);
      nix.settings.max-free = lib.mkForce (20 * 1024 * 1024 * 1024);
      # Sandbox builds on persistent disk — the root is a 3.9GB tmpfs
      # which is too small for kernel cross-compilation scratch files
      nix.settings.build-dir = "/nix/.rw-store/builds";
      systemd.tmpfiles.rules = [ "d /nix/.rw-store/builds 0755 root root -" ];
      # Post-build-hook: push to attic cache (token shared from host via /var/keys/)
      nix.extraOptions = ''
        post-build-hook = ${pkgs.writeShellScript "attic-push-hook" ''
          set -eu
          set -f
          TOKEN_FILE="/var/keys/attic-token"
          LOCKFILE="/tmp/attic-push-unavailable"
          if [ -f "$LOCKFILE" ] && ${pkgs.findutils}/bin/find "$LOCKFILE" -mmin -5 2>/dev/null | ${pkgs.gnugrep}/bin/grep -q .; then
            exit 0
          fi
          if [ -f "$TOKEN_FILE" ]; then
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
    };
    maxJobs = 8;
  };

  # Copy attic token to builder VM's shared keys directory
  system.activationScripts.postActivation.text = lib.mkAfter ''
    if [ -f /etc/attic/token ]; then
      mkdir -p /var/lib/linux-builder/keys
      cp /etc/attic/token /var/lib/linux-builder/keys/attic-token
      chmod 0400 /var/lib/linux-builder/keys/attic-token
    fi
  '';

  system.stateVersion = 4;
}
