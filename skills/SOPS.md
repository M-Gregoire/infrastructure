# SOPS Secret Management

This infrastructure uses [sops-nix](https://github.com/Mic92/sops-nix) with [age](https://github.com/FiloSottile/age) encryption to manage secrets. Secrets are stored encrypted in git and decrypted at system activation time on target machines.

## Architecture Overview

```
.sops.yaml                    # Defines age keys and creation rules
secrets/
  datadog.yaml                # Encrypted Datadog monitoring credentials
  attic.yaml                  # Encrypted Attic binary cache token
machines/dev/
  datadog.nix                 # Consumes Datadog monitoring secrets
  attic.nix                   # Consumes attic secrets
flake.nix                     # Imports sops-nix modules (separate for linux/darwin)
```

**Encryption:** age (via SSH host ed25519 keys on deployed machines, personal age key for admin).

**Decryption on target machines:** sops-nix converts the host's SSH ed25519 key (`/etc/ssh/ssh_host_ed25519_key`) to an age key at activation time and uses it to decrypt secrets.

**Decryption on admin machine (idunn):** Uses the personal age key at `~/.config/sops/age/keys.txt`. Note: on macOS, sops may look in `~/Library/Application Support/sops/age/keys.txt` instead. Set `SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt` if decryption fails.

## Flake Integration

Two separate sops-nix inputs exist to follow each platform's nixpkgs:

```nix
# flake.nix inputs
sops-nix-linux = {
  url = "github:Mic92/sops-nix";
  inputs.nixpkgs.follows = "nixpkgs-linux";
};
sops-nix-darwin = { url = "github:Mic92/sops-nix"; };
```

They are included in system configurations automatically:

```nix
# In mkDarwin:
self.inputs.sops-nix-darwin.darwinModules.sops

# In mkNixos:
self.inputs.sops-nix-linux.nixosModules.sops
```

No additional imports are needed in `flake.nix` to use sops — just create a module that references `sops.secrets.*` and import it from the relevant host config.

## .sops.yaml Structure

```yaml
keys:
  - &admin_greg age1604y9...           # Admin personal age key (can always decrypt)
  - &server_hades1 age1fqh...          # Derived from hades-1 SSH host key
  - &server_hades2 age16cw...          # Derived from hades-2 SSH host key
  # ... one entry per machine
  - &server_idunn age16g4...           # Derived from idunn SSH host key

creation_rules:
  - path_regex: secrets/datadog.yaml   # Which secret file this rule applies to
    key_groups:
    - age:
      - *admin_greg                    # Recipients who can decrypt
      - *server_hades1
      # ... only machines that need this secret
```

**Key principle:** Each creation rule lists exactly which machines need access to that secret file. A machine can only decrypt a secret if its age key is listed as a recipient.

## How to Get a Machine's Age Key

The age public key is derived from the machine's SSH host ed25519 key:

```bash
# On the target machine (or via SSH):
ssh-to-age < /etc/ssh/ssh_host_ed25519_key.pub

# Or remotely:
ssh -p 5421 root@machine "cat /etc/ssh/ssh_host_ed25519_key.pub" | ssh-to-age
```

The `ssh-to-age` tool is available via `nix shell nixpkgs#ssh-to-age`.

## Adding a New Secret

### Step 1: Define the creation rule in `.sops.yaml`

Add the new machine keys (if needed) and a creation rule:

```yaml
keys:
  # ... existing keys ...
  - &server_newmachine age1xxx...       # New machine's age key

creation_rules:
  # ... existing rules ...
  - path_regex: secrets/mysecret.yaml
    key_groups:
    - age:
      - *admin_greg                     # Always include admin
      - *server_hades1                  # Include machines that need this secret
      - *server_newmachine
```

### Step 2: Create the encrypted secret file

```bash
cd ~/src/infrastructure

# Create plaintext, then encrypt in-place:
echo 'my_service:
    api_key: "the-secret-value"' > secrets/mysecret.yaml

sops -e -i secrets/mysecret.yaml
```

### Step 3: Verify encryption

```bash
# Decrypt to verify (needs admin age key):
SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt sops -d secrets/mysecret.yaml
```

### Step 4: Create a nix module that consumes the secret

Create `machines/dev/myservice.nix`:

```nix
{ config, lib, pkgs, flake-root, ... }:

{
  # Tell sops-nix where to find the host's age private key
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  # Define the secret — sops-nix decrypts it at activation time
  sops.secrets."my_service/api_key" = {
    sopsFile = builtins.toPath "${flake-root}/secrets/mysecret.yaml";
    mode = "0400";          # File permissions
    owner = "root";         # Optional: file owner (default: root)
    # path = "/etc/myservice/api_key";  # Optional: custom path
    # Default path is /run/secrets/my_service/api_key (Linux)
  };
}
```

### Step 5: Import from host config

```nix
# In machines/hosts/myhostname/default.nix:
{
  imports = [ ../../dev/myservice.nix ];
  # ...
}
```

### Step 6: Git add (critical for flakes)

```bash
git add secrets/mysecret.yaml machines/dev/myservice.nix
```

## Referencing Secrets in Nix Config

### Direct file path (most common)

Use `config.sops.secrets."name".path` to get the path to the decrypted file:

```nix
services.myservice = {
  apiKeyFile = config.sops.secrets."my_service/api_key".path;
};
```

At runtime, this resolves to a path like `/run/secrets/my_service/api_key` containing the plaintext value.

### Custom fixed path

Set `path` on the secret to control where it's decrypted:

```nix
sops.secrets."attic/token" = {
  sopsFile = builtins.toPath "${flake-root}/secrets/attic.yaml";
  path = "/etc/attic/token";   # Decrypted here at activation
  mode = "0400";
};
```

This is useful when non-nix-managed software needs to read the secret from a known location.

### Templates (for environment files / config files with secrets)

Use `sops.templates` to inject secrets into config files at activation time:

```nix
sops.templates."myservice_env" = {
  content = ''
    API_KEY="${config.sops.placeholder."my_service/api_key"}"
    OTHER_SETTING=value
  '';
  owner = config.systemd.services.myservice.serviceConfig.User;
};

# Use in a systemd service:
systemd.services.myservice.serviceConfig = {
  EnvironmentFile = config.sops.templates."myservice_env".path;
};
```

The `sops.placeholder.*` values are replaced with actual secret values at activation time.

### defaultSopsFile vs per-secret sopsFile

Prefer explicit per-secret `sopsFile` entries:

```nix
# Explicit per-secret — safer when multiple modules coexist
sops.secrets."attic/token" = {
  sopsFile = builtins.toPath "${flake-root}/secrets/attic.yaml";
  ...
};
```

**Recommendation:** Use per-secret `sopsFile` to avoid conflicts when a host imports multiple sops modules. If two modules both set `sops.defaultSopsFile` to different files, it will cause a conflict.

## Adding a Machine to an Existing Secret

When a new machine needs access to an already-encrypted secret:

```bash
cd ~/src/infrastructure

# 1. Add the machine's age key to .sops.yaml (under keys: and the relevant creation_rules:)

# 2. Update the encrypted file's recipients:
SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt sops updatekeys secrets/mysecret.yaml

# 3. Import the sops module from the machine's host config
```

## Rotating / Updating a Secret Value

```bash
cd ~/src/infrastructure

# Edit the encrypted file (sops decrypts, opens $EDITOR, re-encrypts on save):
SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt sops secrets/mysecret.yaml
```

## Current Secrets Inventory

| File | Secret Keys | Used By | Machines |
|------|-------------|---------|----------|
| `secrets/datadog.yaml` | `datadog/hades-cluster/api_id`, `datadog/hades-cluster/api_secret` | `machines/dev/datadog.nix` | hades-1..7 |
| `secrets/attic.yaml` | `attic/token` | `machines/dev/attic.nix` | hades-1..7, idunn |

## Troubleshooting

**"Failed to get the data key required to decrypt the SOPS file"**
- On macOS: set `SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt` (sops looks in `~/Library/Application Support/` by default)
- On deployed machines: ensure `/etc/ssh/ssh_host_ed25519_key` exists and the machine's public key is listed as a recipient in `.sops.yaml`

**"no matching creation rules found"**
- The file path doesn't match any `path_regex` in `.sops.yaml`
- When encrypting via stdin, use `sops -e -i <file>` instead of piping

**Secrets not appearing after deploy**
- Check that the host config imports the relevant dev module (e.g., `../../dev/attic.nix`)
- Check that the machine's age key is in the creation rule for that secret file
- Run `sops updatekeys secrets/file.yaml` after adding a new recipient

**Multiple sops modules conflicting**
- Avoid using `sops.defaultSopsFile` in multiple imported modules
- Use per-secret `sopsFile` attribute instead
- `sops.age.sshKeyPaths` is a list and merges safely across modules (duplicates are harmless)
