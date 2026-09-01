# nix-deploy

Unified NixOS/nix-darwin deployment tool at `bin/nix-deploy`. Handles local macOS/Linux builds, cross-compilation for Raspberry Pi (aarch64-linux), and remote deployment via deploy-rs.

## Commands

### `nix-deploy local [build|switch]`

Deploy or build the current machine's configuration. Automatically detects whether to use `darwin-rebuild` (macOS) or `nixos-rebuild` (Linux).

```bash
nix-deploy local            # Build and switch to new generation
nix-deploy local build      # Build only, don't activate
nix-deploy local switch     # Same as 'nix-deploy local'
```

- Forces local building (overrides remote builders with `--option builders ""`)
- Can run an optional `NIX_DEPLOY_PRIVILEGE_COMMAND` from private config before sudo-based local deploys
- Do NOT run with `sudo` — the script handles privilege escalation internally

### `nix-deploy build <HOST> [HOST...]`

Build a configuration without deploying. Useful for pre-building or validating.

```bash
nix-deploy build mimir          # Build mimir config
nix-deploy build hades-1        # Cross-build hades-1 (aarch64-linux)
nix-deploy build hades          # Build all hades cluster nodes
nix-deploy build all            # Build all hosts
```

- Detects cross-platform builds automatically
- Cross-builds use the linux-builder VM on macOS
- Loads GitHub token from `GITHUB_TOKEN`, `NIX_DEPLOY_GITHUB_TOKEN_COMMAND`, or Bitwarden for private flake access

### `nix-deploy deploy <HOST> [HOST...] [OPTIONS]`

Deploy configuration to remote hosts.

```bash
nix-deploy deploy mimir             # Deploy to mimir (remote build on target)
nix-deploy deploy hades-1 --local   # Cross-compile locally, copy closure, activate
nix-deploy deploy hades --local     # Deploy to all hades nodes (local build)
nix-deploy deploy all               # Deploy to all hosts
nix-deploy deploy local-hosts       # Deploy to mimir, idunn
```

**Two deployment modes for remote hosts:**

1. **Remote build (default):** Uses deploy-rs. The target machine builds its own config. Good for x86_64 hosts with enough resources.
2. **Local build (`--local`):** Cross-compiles on the current machine, copies the closure via `nix copy --to ssh-ng://`, then activates on the target. Required for RPi nodes (too slow to build on-device).

For aarch64-linux targets, the script prompts to cross-compile locally if `--local` or `--remote` isn't specified.

### `nix-deploy list`

Show all available hosts from `hosts.json` plus private host overlays with their system, profile, network, and cluster.

### `nix-deploy update-private-lock [--push]`

Pin the public `flake.lock` to the current `infrastructure-private` commit.

```bash
nix-deploy update-private-lock        # update and stage flake.lock
nix-deploy update-private-lock --push # push private repo first, then update/stage flake.lock
```

The command refuses to run if the private repo has uncommitted changes. Without
`--push`, it warns if the private commit is ahead of its upstream.

## Options

| Flag | Description |
|------|-------------|
| `--local` | Cross-compile locally instead of building on the target |
| `--remote` | Force remote building, skip cross-compile prompt |
| `--switch` | Activate the new generation immediately (restart services, etc.) |
| `--dry` | Dry run — build only, don't activate |
| `--skip-checks` | Skip deploy-rs evaluation checks (added automatically) |
| `--push` | For `update-private-lock`: push private config before updating `flake.lock` |

## Activation: boot vs switch

When deploying to remote hosts with `--local`, the default activation action is **boot**:

- **`boot` (default):** Sets the new generation as the boot default. Services are NOT restarted. Requires a reboot to fully activate. Safe for production — no downtime during deploy.
- **`--switch`:** Activates immediately. Restarts changed systemd services, updates the running system. The machine does not need a reboot.

```bash
# Deploy but don't activate until reboot (safe, default)
nix-deploy deploy hades-1 --local

# Deploy and activate immediately (restarts services)
nix-deploy deploy hades-1 --local --switch
```

When deploying via deploy-rs (without `--local`), activation behavior is controlled by deploy-rs itself (defaults to switch with auto-rollback).

## Host Groups

| Group | Expands to |
|-------|-----------|
| `all` | Every host in `hosts.json` |
| `hades` | All hosts with `cluster: "hades"` (hades-1 through hades-7) |
| `local-hosts` | mimir, idunn |

## How It Works

### Local deployment (`nix-deploy local`)

1. Matches current hostname to a config in `hosts.json`
2. Runs `darwin-rebuild switch --flake .?submodules=1#<host>` (macOS) or `nixos-rebuild switch --flake .#<host>` (Linux)
3. Forces local build with `--option builders "" --option max-jobs auto`

### Remote cross-compile deployment (`nix-deploy deploy <host> --local`)

1. Builds: `nix build .#nixosConfigurations.<host>.config.system.build.toplevel`
2. Copies closure: `nix copy --no-check-sigs --to ssh-ng://root@<host>`
3. Activates: `ssh root@<host> "nix-env -p /nix/var/nix/profiles/system --set <path> && <path>/bin/switch-to-configuration boot|switch"`

### Remote deploy-rs deployment (`nix-deploy deploy <host>`)

1. Runs `deploy .#<host> --skip-checks` (plus any extra args)
2. deploy-rs handles build, copy, and activation with auto-rollback

## Configuration

Public host metadata lives in `hosts.json` at the repo root. Private host metadata can be overlaid from `infrastructure-private/hosts.json`. Each entry specifies:

```json
{
  "hades-1": {
    "hostname": "hades-1.martinache.net",
    "system": "aarch64-linux",
    "profile": "server",
    "network": "home",
    "cluster": "hades",
    "clusterRole": "worker",
    "user": "gregoire",
    "sshPort": "5421"
  }
}
```

The `system` field determines whether cross-compilation is needed. The `hostname` (or `deployHostname`) and `sshPort` fields are used for SSH connections.

## GitHub Token

The script loads a GitHub token for private flake access. Sources are tried in this order:

1. Existing `GITHUB_TOKEN`
2. `NIX_DEPLOY_GITHUB_TOKEN_COMMAND` from private config
3. Bitwarden item `github-nix-token`

The token is passed to nix via `--option access-tokens`.

## Attic Binary Cache

Home-network machines automatically push artifacts to the Attic binary cache at `nix-cache.martinache.net/hades` via a post-build-hook (configured in `machines/networks/home/default.nix`). This means:
- After cross-compiling for hades-1, deploying to hades-2..6 pulls from cache instead of rebuilding
- The hook is a no-op on machines without `/etc/attic/token` (see `skills/SOPS.md` for setup)
