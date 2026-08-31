# Nix Build Infrastructure

How builds work on this infrastructure: the linux-builder VM, the attic binary cache, cross-compilation, and supported architectures.

## Architecture Overview

```
idunn (macOS, aarch64-darwin)
  |
  +-- nix daemon
  |     +-- linux-builder VM (NixOS, Apple Virtualization.framework)
  |     |     +-- aarch64-linux: native (near-native speed)
  |     |     +-- x86_64-linux:  via Rosetta 2 translation
  |     |     Configured in: machines/hosts/idunn/default.nix (nix.linux-builder)
  |     |     Managed by: launchd (org.nixos.linux-builder)
  |     |
  |     +-- post-build-hook → attic push (machines/networks/home/default.nix)
  |           Pushes built paths to nix-cache.martinache.net/hades from home-network hosts
  |
  +-- attic binary cache (nix-cache.martinache.net/hades)
        Served via Traefik IngressRoute on the hades k3s cluster
        Home-network machines (hades-1..7, idunn) are configured as substituters
```

## Linux Builder VM

The linux-builder is a NixOS VM running under Apple's Virtualization.framework (VZ) on macOS. It handles both `aarch64-linux` (native ARM64) and `x86_64-linux` (via Rosetta 2 translation) builds from a single VM.

### Configuration

The builder VM is configured in `machines/hosts/idunn/default.nix`:

```nix
nix.linux-builder = {
  enable = true;
  package = pkgs-unstable.darwin.linux-builder-vz;  # VZ backend (from nixpkgs-unstable)
  systems = [ "aarch64-linux" "x86_64-linux" ];
  config = {
    virtualisation = {
      cores = 8;
      memorySize = lib.mkForce 8192;          # 8 GB RAM
      diskSize = lib.mkForce (60 * 1024);     # 60 GB disk
    };
    networking.nameservers = [ "192.168.3.1" ];  # Local DNS for nix-cache resolution
    nix.settings = {
      always-allow-substitutes = true;
      extra-substituters = [ "https://nix-cache.martinache.net/hades" ];
      extra-trusted-public-keys = [ "hades:pWcHX3vzVabOBcdgMn+oesgqYxKvda27XQrRicRzK/0=" ];
    };
  };
  maxJobs = 8;
};
```

### Key Details

- **Backend**: `darwin.linux-builder-vz` — Apple Virtualization.framework (NOT QEMU)
- **Package source**: `nixpkgs-unstable` — the VZ builder is in nixos-unstable and will land in stable NixOS 26.11. It's not in 26.05.
- **Architectures**: aarch64-linux (native), x86_64-linux (Rosetta 2)
- **Rosetta requirement**: macOS must have Rosetta installed (`softwareupdate --install-rosetta --agree-to-license`)
- **Launchd service**: `org.nixos.linux-builder` (plist at `/Library/LaunchDaemons/org.nixos.linux-builder.plist`)
- **VM disk**: `/var/lib/linux-builder/nixos.qcow2` (raw disk, despite the `.qcow2` extension)
- **SSH access**: Port 31022 on localhost, key at `/etc/nix/builder_ed25519` (needs sudo)
- **Boot chain**: `linux-builder-start` waits for `/nix/store`, then runs `create-builder` → `run-builder` → VZ VM

### Builder VM Config Notes

The builder VM is a **separate NixOS system** with its own `nix.conf`. This means:

- **DNS**: Must be configured independently. Set `networking.nameservers = [ "192.168.3.1" ]` so it can resolve `nix-cache.martinache.net` (local-only hostname). Without this, the VM uses public DNS which can't resolve local services.
- **Substituters**: Must be configured independently. The home-network config in `machines/networks/home/default.nix` doesn't apply to the builder VM — add `extra-substituters` and `extra-trusted-public-keys` in the builder's `nix.settings`.
- **`lib.mkForce`**: Required for `memorySize` and `diskSize` because the VZ module sets its own defaults (3072 MB / 20 GB) that conflict without forced override.

### Managing the Builder

```bash
# Restart the builder VM
sudo launchctl kickstart -k system/org.nixos.linux-builder

# Stop the builder
sudo launchctl bootout system/org.nixos.linux-builder

# Start the builder
sudo launchctl bootstrap system /Library/LaunchDaemons/org.nixos.linux-builder.plist

# SSH into the builder (needs sudo for the key)
sudo ssh -p 31022 -i /etc/nix/builder_ed25519 builder@localhost

# Garbage-collect inside the builder
sudo ssh -p 31022 -i /etc/nix/builder_ed25519 builder@localhost nix-collect-garbage
```

### Applying Builder Config Changes

After changing `nix.linux-builder.config` in idunn's config:

1. Run `nix-deploy local` to rebuild idunn's config
2. The launchd service restarts automatically with the new VM image
3. The old VM disk is replaced on next boot

**Force fresh start** (if the VM is stuck with old config):

```bash
sudo launchctl bootout system/org.nixos.linux-builder
sudo rm /var/lib/linux-builder/nixos.qcow2
sudo launchctl bootstrap system /Library/LaunchDaemons/org.nixos.linux-builder.plist
```

**Bootstrap caveat**: The builder VM's NixOS system is an aarch64-linux derivation. Building idunn's config requires a working builder. If the builder is broken, `nix-deploy local` (which passes `--option builders ""`) will fail. Instead, build directly with `nix build` (without disabling builders) using a working builder, then activate with `darwin-rebuild switch`.

## Attic Binary Cache

The attic binary cache at `nix-cache.martinache.net/hades` accelerates builds by sharing build artifacts across home-network machines.

### How It Works

1. **Substituters** (pull): Home-network machines are configured in `machines/networks/home/default.nix` to use the cache as a substituter:
   ```nix
   nix.settings = {
     substituters = [ "https://nix-cache.martinache.net/hades" ];
     trusted-public-keys = [ "hades:pWcHX3vzVabOBcdgMn+oesgqYxKvda27XQrRicRzK/0=" ];
     connect-timeout = 5;   # Fail fast if cache is down
     fallback = true;       # Fall back to building if cache fails
   };
   ```

2. **Post-build-hook** (push): Successful builds on home-network machines automatically push to the cache via a post-build-hook defined in `machines/networks/home/default.nix`. The hook:
   - Checks for `/etc/attic/token` (no-op without it)
   - Does a 3-second connectivity check before pushing
   - Times out after 30 seconds per push
   - Sets a 5-minute cooldown lockfile if the cache is unreachable

3. **Manual push**: To push a specific build result:
   ```bash
   attic push hades $(readlink -f result)
   ```

### DNS Requirement

The attic cache runs behind Traefik with a DNS IngressRoute on the hades k3s cluster. This means:
- Clients must resolve `nix-cache.martinache.net` via the local DNS server (192.168.3.1)
- Direct IP access won't work (Traefik needs the hostname for routing)
- The linux-builder VM must have `networking.nameservers = [ "192.168.3.1" ]` (public DNS like 8.8.8.8 can't resolve local services)

### Attic Token

The attic token is managed via sops-nix (see `skills/SOPS.md`). The encrypted token is in `secrets/attic.yaml` and decrypted to `/etc/attic/token` on machines that import `machines/dev/attic.nix`.

## Build Workflow

### Building a Single Host

```bash
cd ~/src/infrastructure

# Build hades-6 (cross-compiles via linux-builder VM)
bin/nix-deploy build hades-6

# Push result to attic cache (usually automatic via post-build-hook)
attic push hades $(readlink -f result)
```

### Building and Deploying

```bash
# Build + deploy to a single node
bin/nix-deploy deploy hades-6 --local

# Build + deploy to all hades nodes
bin/nix-deploy deploy hades --local
```

See `skills/NIX-DEPLOY.md` for full deployment documentation.

### Build Flow for RPi Nodes

1. `nix-deploy build hades-6` detects aarch64-linux target on aarch64-darwin host
2. Nix delegates the Linux derivations to the linux-builder VM (via SSH on port 31022)
3. The builder VM fetches substitutes from both `cache.nixos.org` and `nix-cache.martinache.net/hades`
4. Built paths are copied back to idunn's nix store
5. The post-build-hook pushes new paths to the attic cache
6. Subsequent builds of other hades nodes pull shared paths from attic instead of rebuilding

## Historical Notes

### Migration from QEMU to VZ

The builder originally used `pkgs.darwin.linux-builder` (QEMU + Apple HVF). This only supported aarch64-linux. The QEMU backend is **not compatible** with Rosetta — adding `rosetta.enable = true` to a QEMU builder adds `/run/rosetta` to `extra-sandbox-paths` in the VM's nix.conf, but QEMU doesn't mount a Rosetta virtiofs share, so `/run/rosetta` doesn't exist and **all builds fail** (nix aborts if any sandbox path is missing).

The fix was to switch to `pkgs.darwin.linux-builder-vz`, which uses Apple Virtualization.framework and properly exposes Rosetta to the Linux guest via virtiofs.

**When switching from QEMU to VZ**, you must delete the old VM disk first — the VZ backend expects a raw disk image, not a QEMU qcow2 image:

```bash
sudo launchctl bootout system/org.nixos.linux-builder
sudo rm /var/lib/linux-builder/nixos.qcow2
# Then rebuild idunn and restart the service
```

## Troubleshooting

### "failed to start SSH connection to 'linux-builder'"

The builder VM isn't running. Restart it:

```bash
sudo launchctl kickstart -k system/org.nixos.linux-builder
```

If not loaded:

```bash
sudo launchctl list | grep linux-builder
sudo launchctl bootstrap system /Library/LaunchDaemons/org.nixos.linux-builder.plist
```

### "lacks a signature by a trusted key"

The builder VM doesn't trust the signing key for paths it's receiving. Ensure the builder's config includes:

```nix
nix.settings.extra-trusted-public-keys = [ "hades:pWcHX3vzVabOBcdgMn+oesgqYxKvda27XQrRicRzK/0=" ];
```

Then rebuild idunn (`nix-deploy local`) and restart the builder.

### "Could not resolve host: nix-cache.martinache.net" (from builder VM)

The builder VM's DNS can't resolve local hostnames. Ensure:

```nix
# In nix.linux-builder.config:
networking.nameservers = [ "192.168.3.1" ];
```

### Stale nix store paths in the builder

If the builder VM has stale paths (e.g., after a nix store GC on the host), builds may fail with missing store path errors. Fix by GC'ing inside the builder:

```bash
sudo ssh -p 31022 -i /etc/nix/builder_ed25519 builder@localhost nix-collect-garbage
```

### Builder VM disk full

The builder disk is 60 GB. If builds fail with "No space left on device", GC inside the builder or increase `diskSize` in the builder config.

### Platform mismatch errors during `nix-deploy local`

`nix-deploy local` passes `--option builders ""`, which disables the builder VM. Since the builder's NixOS system is an aarch64-linux derivation, this causes "platform mismatch" errors. Build directly with `nix build` instead:

```bash
cd ~/src/infrastructure
nix build '.?submodules=1#darwinConfigurations.idunn.system'
sudo darwin-rebuild switch --flake '.?submodules=1#idunn'
```
