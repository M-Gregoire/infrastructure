``` sh
nix flake lock
nix run github:nix-community/nixos-anywhere -- --flake .#orion --generate-hardware-config nixos-generate-config ./hardware-configuration.nix root@137.74.1.223
```

``` sh
nix run github:nix-community/nixos-anywhere -- --flake .#orion root@137.74.1.223 
```

# KVM

``` sh
nix-shell -p adoptopenjdk-icedtea-web
$ javaws /path/to/your/downloaded.jnlp
```

