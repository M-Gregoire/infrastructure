# Caching

This explains the two independent, easily-confused ways to skip
`nix-cache.martinache.net` (the private Attic cache, hosted on hades and
reachable only via the home LAN/netbird/WireGuard), and how they relate to
`cache.nixos.org` (the public cache, always reachable).

## The two mechanisms

### 1. `--no-cache` flag — per-invocation, on *this Mac's* own substituters

Works with `nix-deploy build`, `nix-deploy deploy ... --local`, and
`nix-deploy local`. It skips `nix-cache.martinache.net` for **that one
command only** — it doesn't persist, doesn't change any file, and doesn't
affect any other command (including a later one run without the flag).

```sh
nix-deploy build hades-2 --no-cache
nix-deploy deploy hades-2 --local --switch --no-cache
nix-deploy local switch --no-cache
```

Use this when a single command needs to skip an unreachable cache right
now. If you don't pass it, that command uses your normal substituters
(`nix-cache.martinache.net` + `cache.nixos.org`), exactly as if nothing
about caching had ever been touched.

### 2. `bin/builder-no-cache` / `bin/builder-with-cache` — persistent, on the linux-builder VM

The linux-builder VM (used for cross-compiling aarch64-linux/x86_64-linux,
e.g. for the hades nodes) is a **separate NixOS system with its own
independent nix-daemon and its own `/etc/nix/nix.conf`**. When it builds or
copies a cross-compiled derivation, *it* decides whether to check
`nix-cache.martinache.net` — using its own config, not anything passed from
this Mac. There is no per-invocation flag that reaches that decision (see
"Why this needs a VM rebuild" below).

So toggling it means editing the VM's declared config
(`machines/hosts/idunn/default.nix`, the `nix.linux-builder.config.nix.settings.extra-substituters`
line) and rebuilding+resetting the VM to bake in the new closure:

```sh
bin/builder-no-cache    # disables it on the VM, rebuilds idunn, resets the VM
bin/builder-with-cache  # re-enables it, rebuilds idunn, resets the VM
```

This is slow (a full VM store rebuild, often several minutes) and
**persists** until you run the other script — every subsequent cross-build
through the VM is affected, not just one command.

## Which one do I want?

| Situation | Use |
|---|---|
| One `nix-deploy build`/`deploy --local`/`local` command, cache unreachable right now | `--no-cache` on that command |
| Doing a stretch of cross-builds (hades-X) while away from a network where the cache resolves | `bin/builder-no-cache` once, then build normally; `bin/builder-with-cache` when back |
| Rebuilding idunn itself, cache unreachable | `nix-deploy local switch --no-cache` |
| Cache is reachable, want it back everywhere | `bin/builder-with-cache` (and just don't pass `--no-cache` elsewhere) |

They're independent: running `builder-no-cache` does **not** make `nix-deploy
build hades-2` (without the flag) skip the cache — that's still a separate,
explicit decision per command.

## Why this needs a VM rebuild (things that didn't work)

Two approaches were tried and failed before landing on sed'ing the config
directly:

- **An impure marker file** (`builtins.pathExists /tmp/some-marker`) looked
  like it worked but never actually did: flakes' restricted evaluation makes
  `builtins.pathExists` silently return `false` for *any* path outside the
  flake's own source tree — verified directly, even `/nix/store` itself
  reads as "not existing" from inside eval. A marker has to live inside the
  repo and be git-tracked to be visible at all, which is why the scripts
  now `sed` `idunn/default.nix`'s tracked content directly instead (no `git
  add` needed for that — flakes' dirty-tree tolerance already picks up
  working-tree edits to already-tracked files, only brand-new files need
  staging).

- **Passing `NIX_CONFIG` through to the VM's remote-build SSH session**
  isn't a thing Nix supports for `ssh-ng://` builders — the remote side
  decides substitution using its own local config, not anything the client
  requests over the wire. (There's a theoretical `remote-program` store-URI
  trick to inject an env var into the remote session, but it's fragile and
  wasn't pursued.)

## Related nix-daemon gotchas found along the way

These bit the `--no-cache` flag specifically and are fixed in `nix-deploy`,
noted here so they don't get re-discovered from scratch:

- **`trusted-users`**: nix-daemon silently ignores a client's substituter
  override unless the invoking user is in `trusted-users` (defaulted to
  just `root`). Fixed by adding the user to `nix.settings.trusted-users` in
  `machines/profiles/PC/default.nix`.
- **`sudo` strips environment variables**: `cmd_local`'s darwin/nixos
  branches `exec` through plain `sudo` (needed for system activation),
  which resets the environment by default — `NIX_CONFIG` never reached the
  root-owned rebuild process. Fixed by passing literal `--option` flags on
  the rebuild command instead, which survive the `sudo` boundary regardless
  of environment stripping. (`cmd_build` doesn't have this problem — it
  calls `nix build` directly, no `sudo` involved.)
