# Install

## Standard install (BIOS)

```
parted /dev/sda -- mklabel msdos
parted -a optimal /dev/sda -- mkpart primary 1MiB -8GiB
parted -a optimal /dev/sda -- mkpart primary linux-swap -8GiB 100%
mkfs.ext4 -L nixos /dev/sda1
mkswap -L swap /dev/sda2
mount /dev/disk/by-label/nixos /mnt
swapon /dev/sda2
nixos-generate-config --root /mnt

# Copy initial-config.nix to /etc/nixos/configuration.nix
# Uncomment BIOS section and comment the EFI section
# Also copy wpa_supplicant.conf in /etc if Wifi is needed
# /!\ Save hardware-configuration.nix to this repo!

nixos-install
reboot
```

## Standard install (UEFI)

```
parted /dev/sda -- mklabel gpt
parted -a optimal /dev/sda -- mkpart primary 512MiB -8GiB
parted -a optimal /dev/sda -- mkpart primary linux-swap -8GiB 100%
parted -a optimal /dev/sda -- mkpart ESP fat32 1MiB 512MiB
parted /dev/sda -- set 3 boot on
mkfs.ext4 -L nixos /dev/sda1
mkswap -L swap /dev/sda2
mkfs.fat -F 32 -n boot /dev/sda3
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
swapon /dev/sda2
nixos-generate-config --root /mnt

# Copy initial-config.nix to /etc/nixos/configuration.nix
# Also copy wpa_supplicant.conf in /etc if Wifi is needed
# /!\ Save hardware-configuration.nix to this repo!

nixos-install
reboot
```

## LVM/LUKS install
This documentation describes how to install NixOS with LVM and LUKS.
This is heavily based on [https://qfpl.io/posts/installing-nixos/](https://qfpl.io/posts/installing-nixos/).

```
gdisk /dev/sda
# List partition
Command: p
# Delete all current partition
Command: d
# Create EFI partition
Command: n
Partition number: 1
First sector: <enter for default>
Last sector: +1G       --  make a 1 gigabyte partition
Hex code or GUID: ef00 -- this is the EFI System type
# Create LVM partition
Command: n
Partition number: 2
First sector: <enter for default>
Last sector: <enter for default - rest of disk>
Hex code or GUID: 8e00 -- Linux LVM type
# Write and quit
Command: w


cryptsetup luksFormat /dev/sda2

# Decrypt the encrypted partition and call it nixos-enc. The decrypted partition will get mounted at /dev/mapper/nixos-enc.
cryptsetup luksOpen /dev/sda2 nixos-enc

# Create the LVM physical volume using nixos-enc.
pvcreate /dev/mapper/nixos-enc

# Create a volume group that will contain our root and swap partitions.
vgcreate nixos-vg /dev/mapper/nixos-enc

# Create a swap partition that is 8G in size. Volume is labeled "swap"'.
lvcreate -L 8G -n swap nixos-vg

# Create a logical volume for our root filesystem from all remaining free space. Volume is labeled "root".
lvcreate -l 100%FREE -n root nixos-vg

# Create a FAT32 filesystem on our boot partition
mkfs.vfat -n boot /dev/sda1

# Create an ext4 filesystem for our root partition
mkfs.ext4 -L nixos /dev/nixos-vg/root

# Tell our swap partition to be a swap
mkswap -L swap /dev/nixos-vg/swap

# Turn the swap on before install
swapon /dev/nixos-vg/swap

# Mount partitions
mount /dev/nixos-vg/root /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot

# Generate config
nixos-generate-config --root /mnt

# Copy initial-config.nix to /etc/nixos/configuration.nix
# Also copy wpa_supplicant.conf in /etc if Wifi is needed
# Edit initial-config.nix to uncomment LUKS section
# And set correct Luks drive
# /!\ Save hardware-configuration.nix to this repo!

# Install
nixos-install
reboot

# Make sure you use the correct hardware-config and that LUKS drive variable is correctly set
# For your host and deploy using nixops from another device.
# If no other device is available, go to the next step directly.
```

## Post-install for PCs
Everything should now be installed on the host. However, local deployement will not work as the github repo will not have been cloned, channels are not set and some local files might be missing. To do so, on the newly installed device:

```
# On a TTY:
passwd <user>
# Connect <user> using the Display Manager

# Add channels
nix-channel --add https://nixos.org/channels/nixpkgs-unstable unstable &&\
nix-channel --add https://nixos.org/channels/nixos-20.09 nixos &&\
nix-channel --add https://github.com/rycee/home-manager/archive/release-20.09.tar.gz home-manager &&\
nix-channel --update

# Add also for root so you can use nixos-rebuild and not only nixops
sudo bash -c "nix-channel --add https://nixos.org/channels/nixpkgs-unstable unstable &&\
nix-channel --add https://nixos.org/channels/nixos-20.09 nixos &&\
nix-channel --add https://github.com/rycee/home-manager/archive/release-20.09.tar.gz home-manager &&\
nix-channel --update"

# Restore {.thunderbird, .mozilla, .gnupg} and clone both the public and private github repo

sudo nixos-rebuild switch
```

## Mount from live with LUKS
```
cryptsetup luksOpen /dev/sda2 nixos-enc
lvscan
vgchange -ay
mount /dev/nixos-vg/root /mnt
swapon /dev/nixos-vg/swap
mount /dev/sda1 /mnt/boot
nixos-enter
```
