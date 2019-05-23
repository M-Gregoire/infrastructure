# How I install a new device

- Install nixos like you normaly would and use `initial-config.nix` by copying it in `/mnt/etc/nixos/configuration.nix` before running `nixos-install`.
- Reboot in your new, empty nixos system.
- Use `nixops` to deploy to this new device using the appropriate section of this readme (or clone this repo and install using nixos-rebuild).

# How to clone

Clone this repo using
```sh
git clone --recurse-submodules
```

Update submodules
```sh
git submodule update --recursive --remote
```

## Install using with nixos-rebuild

Make sure to symlink the corresponding config:

```sh
sudo ln -s ${PWD}/nixos/hosts/<Host>/configuration.nix /etc/nixos
# Be sure the hardware-configuration.nix you are linking is up to date!
# Especially after HDD/SSD change!
sudo ln -s ${PWD}/nixos/hosts/<Host>/hardware-configuration.nix /etc/nixos
```

When first building, specify config using:

```sh
sudo nixos-rebuild -I nixos-config=${PWD}/nixos/hosts/<Host>/configuration.nix -I nixpkgs=${PWD}/vendor/nixpkgs-release switch
```

# Clean

```sh
nixops ssh-for-each 'nix-collect-garbage -d'
```

## Install using nixops

```sh
cd nixops
nixops create home.nix Bur.nix Mimir.nix Skuld.nix -d home
nixops deploy -d home # Deploy to all machines
nixops deploy -d home --include Skuld ## Deploy only to Skuld
```

## Force Delete

``` sh
nixops destroy -d <uid>
nixops delete -d <uid>
```

### Useful commands

```sh
nixops list
nixops info -d home
```

### Notes

Using a software without installing:

```sh
nix run nixpkgs.usbutils -c lsusb
```

Test a package while developing:

```sh
nix-env -f ~/src/github.com/m-gregoire/dotfiles-nix/vendor/nixpkgs-m-gregoire -i <PACKAGE>
```

### Theming

Every applications is themed automatically using the defined base16 theme.
I manually created the templates in `./home/theme` expect for a few were I used `base16-builder`.
