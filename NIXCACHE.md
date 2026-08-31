# Nix Binary Cache (Attic) for Hades Cluster

## Context

Building NixOS generations for the 6 RPi 4 (aarch64) hades nodes is slow — kernel compilation on RPi takes a long time, and there's no caching between nodes. Attic is a self-hosted Nix binary cache that stores build outputs locally so they only need to be built once. After building for one RPi, the other 5 pull from cache instead of rebuilding.

## Claude Conversation

Project ID: `4aaa1344-e6e6-4c0f-9bac-def83194393b`

## What's Done

Deployed Attic + PostgreSQL to hades k8s cluster (committed and pushed to `hades-cluster` repo):

- `manifests/apps/attic/kustomization.yaml` — resources + configMapGenerator for server.toml
- `manifests/apps/attic/pvc.yaml` — `attic-db-pvc` (5Gi) + `attic-data-pvc` (100Gi) on rook-ceph-fast-block
- `manifests/apps/attic/secret.yaml` — PostgreSQL passwords + HS256 JWT signing key
- `manifests/apps/attic/release.yaml` — Bitnami PostgreSQL HelmRelease
- `manifests/apps/attic/files/server.toml` — Attic server config (zstd compression, 6-month GC retention)
- `manifests/apps/attic/deployment.yaml` — Attic container (ghcr.io/zhaofengli/attic:latest)
- `manifests/apps/attic/svc.yaml` — ClusterIP on port 8080
- `manifests/apps/attic/ingress.yaml` — Traefik IngressRoute for `nix-cache.martinache.net`

Commit: `80811b0` on `main` in `hades-cluster` repo.

## TODO

### 1. Wait for Flux reconciliation

```bash
# Force reconciliation:
flux reconcile kustomization apps --context hades

# Verify:
kubectl --context hades get deploy,svc,pvc,ingressroute -n apps -l app=attic
kubectl --context hades logs -n apps deploy/attic
```

### 2. Create admin token and cache

```bash
# Exec into the attic pod
kubectl --context hades exec -it -n apps deploy/attic -- sh

# Create admin token (inside pod)
atticadm make-token -f /config/server.toml \
  --sub "admin" --validity "10y" \
  --pull "*" --push "*" --delete "*" \
  --create-cache "*" --configure-cache "*" \
  --configure-cache-retention "*" --destroy-cache "*"

# On local machine: configure attic client
attic login hades https://nix-cache.martinache.net <token>
attic cache create hades
attic cache configure --public hades
```

### 3. Configure NixOS nodes as substituters

Add to the infrastructure repo (nix config for hades nodes):

```nix
nix.settings = {
  substituters = [ "https://nix-cache.martinache.net/hades" ];
  trusted-public-keys = [ "<key from 'attic cache info hades'>" ];
};
```

### 4. Push builds to cache

After building for one node, push the closure to the cache so other nodes can pull:

```bash
attic push hades /nix/store/<path>
```
