# Backporting Ceph AES256K Patches to RPi Vendor Kernel 6.18

## Context

The Ceph `aes256k` CephX key type (CVE-2025-30156) requires Linux kernel 7.0+
for kernel client support (`krbd`, kernel `rbd` and `ceph` modules). The hades
RPi4 nodes run the RPi vendor kernel 6.18.34 from `nixos-raspberrypi`. Mainline
7.x doesn't boot on RPi4 (missing RPi patches/device tree), so we backport the
5 AES256K commits from 7.0 to 6.18 via `boot.kernelPatches`.

## The Patches

Ilya Dryomov's "Ceph updates for 7.0-rc1" pull request:
https://lore.kernel.org/lkml/20260217173743.1840319-1-idryomov@gmail.com/

Five commits, must be applied in order:

| # | Commit | Title |
|---|--------|-------|
| 1 | `ac431d597a9b` | libceph: define and enforce CEPH_MAX_KEY_LEN |
| 2 | `0ee8bccf7396` | libceph: generalize ceph_x_encrypt_offset() and ceph_x_encrypt_buflen() |
| 3 | `6cec0b61aacc` | libceph: introduce ceph_crypto_key_prepare() |
| 4 | `b7cc142dbafe` | libceph: add support for CEPH_CRYPTO_AES256KRB5 |
| 5 | `8356b4b1103b` | libceph: adapt ceph_x_challenge_blob hashing and msgr1 message signing |

Commits 1-3 are infrastructure/refactoring. Commit 4 is the actual AES256KRB5
implementation. Commit 5 adapts challenge blob hashing and msgr1 signing.

The other commits in the pull (CephFS fscrypt fixes by Sam Edwards, snapshot
context fixes by ethanwu) are unrelated to AES256K and can be skipped.

### Files Touched

All in `net/ceph/` (libceph):
- `crypto.c` — 275 lines: `ceph_crypto_key_prepare()`, AES256-CTS-HMAC-SHA384-192 setup, scatterlist encrypt/decrypt with confounder
- `crypto.h` — 21 lines: new `krb5_tfms[]` array, `hmac_key` fields
- `auth_x.c` — 195 lines: generalized encrypt offset/buflen, HMAC-SHA256 challenge blob hashing
- `auth_x_protocol.h` — 38 lines: new AES256KRB5 protocol constants
- `messenger_v2.c` — 16 lines: messenger v2 crypto adaptations
- `Kconfig` — 1 line: `select CRYPTO_KRB5`

No changes to `drivers/block/rbd.c` — RBD uses libceph's auth transparently.

### Kernel Config Dependency

The patches add `select CRYPTO_KRB5` to `net/ceph/Kconfig`. The `CRYPTO_KRB5`
subsystem was merged in Linux 6.12, so RPi vendor kernel 6.18 already has it.
No separate `CONFIG_CEPH_LIB_USE_AES256` toggle — AES256K support is built
automatically when `CONFIG_CEPH_LIB` is enabled.

## NixOS Implementation

### How `boot.kernelPatches` Works

Each entry is an attrset with:
- `name` (string) — descriptive identifier
- `patch` (path or derivation, or `null`) — the `.patch` file
- `structuredExtraConfig` (optional) — kernel config options

Patches are applied in order during the kernel build phase. Use `fetchpatch`
to pull individual commits from git.kernel.org or GitHub.

### Configuration

Add to the shared hades config (`machines/hosts/hades/default.nix`) so it
applies to all RPi4 nodes once they're on the 6.18 kernel. Since hades-7 is
x86_64 and may already be on kernel 7.0+, guard with a conditional or put it
in the RPi-specific config.

```nix
boot.kernelPatches = [
  {
    name = "libceph-define-enforce-ceph-max-key-len";
    patch = pkgs.fetchpatch {
      url = "https://github.com/torvalds/linux/commit/ac431d597a9bdfc2ba6b314813f29a6ef2b4a3bf.patch";
      hash = "sha256-PLACEHOLDER";
    };
  }
  {
    name = "libceph-generalize-encrypt-offset-buflen";
    patch = pkgs.fetchpatch {
      url = "https://github.com/torvalds/linux/commit/0ee8bccf7396d50726c9c8dd3135fb64a9fe8426.patch";
      hash = "sha256-PLACEHOLDER";
    };
  }
  {
    name = "libceph-introduce-ceph-crypto-key-prepare";
    patch = pkgs.fetchpatch {
      url = "https://github.com/torvalds/linux/commit/6cec0b61aacce4da5125b21c718189f0dc11eb51.patch";
      hash = "sha256-PLACEHOLDER";
    };
  }
  {
    name = "libceph-add-support-ceph-crypto-aes256krb5";
    patch = pkgs.fetchpatch {
      url = "https://github.com/torvalds/linux/commit/b7cc142dbafeaf6c053284ca9121b9f70b6d6d06.patch";
      hash = "sha256-PLACEHOLDER";
    };
  }
  {
    name = "libceph-adapt-challenge-blob-hashing-msgr1-signing";
    patch = pkgs.fetchpatch {
      url = "https://github.com/torvalds/linux/commit/8356b4b1103b8c970648c94bab724aa30e42d869.patch";
      hash = "sha256-PLACEHOLDER";
    };
  }
];
```

To compute hashes: set `hash = "";` and build — the error message will print
the correct hash. Or use `nix-prefetch-url` on each URL.

### Potential Issues

1. **Context conflicts**: patches were written against 6.19/7.0-rc1. The RPi
   6.18 `net/ceph/` may have minor differences. If a patch doesn't apply
   cleanly, download it, manually adjust the context, and use a local file
   path instead of `fetchpatch`.

2. **`CRYPTO_KRB5` config**: should already be available in 6.18 but may need
   to be explicitly enabled. If the build fails on missing KRB5 symbols, add:
   ```nix
   {
     name = "ceph-aes256k-kconfig";
     patch = null;
     structuredExtraConfig = with lib.kernel; {
       CRYPTO_KRB5 = module;
     };
   }
   ```

3. **RPi kernel source**: `nixos-raspberrypi` fetches from
   `github:raspberrypi/linux` (the RPi Foundation vendor fork). The `net/ceph/`
   code in RPi 6.18 should be identical to upstream 6.18 since RPi patches
   only touch `drivers/`, `arch/arm*`, and device tree.

## Steps

1. Add `boot.kernelPatches` to `machines/hosts/hades/hades-6/default.nix`
   (test on hades-6 first)
2. Build with `nix build .#nixosConfigurations.hades-6.config.system.build.toplevel`
   — fix hashes and any patch conflicts
3. Deploy to hades-6, verify boot: `uname -r` should still show `6.18.x`
4. Verify AES256K support: `modprobe rbd ceph`, then test with an AES256K key
5. Rotate CSI keys to AES256K (steps in `hades-cluster/ceph-aes.md`)
6. Once verified, move patches to shared hades config, roll to all RPi4 nodes
7. Lock down `auth_allowed_ciphers` to `aes256k` only

## References

- [Phoronix: Ceph In Linux 7.0 Lands Support For AES256K Keys](https://www.phoronix.com/news/Ceph-Linux-7.0)
- [lore.kernel.org: GIT PULL Ceph updates for 7.0-rc1](https://lore.kernel.org/lkml/20260217173743.1840319-1-idryomov@gmail.com/)
- [NixOS Wiki: Linux kernel](https://wiki.nixos.org/wiki/Linux_kernel)
- [MyNixOS: boot.kernelPatches option](https://mynixos.com/nixpkgs/option/boot.kernelPatches)
- [NixOS Discourse: Fetching patches from lore.kernel.org](https://discourse.nixos.org/t/fetching-patches-from-lore-kernel-org/45594)
- [GitHub: nvmd/nixos-raspberrypi](https://github.com/nvmd/nixos-raspberrypi)
- [GitHub: raspberrypi/linux](https://github.com/raspberrypi/linux)
- `hades-cluster/ceph-aes.md` — full AES256K migration status
- `hades-cluster/kernel-upgrade.md` — RPi kernel 6.18 upgrade status
