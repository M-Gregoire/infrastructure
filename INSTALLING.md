# Install

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

-- Create a FAT32 filesystem on our boot partition
# mkfs.vfat -n boot $BOOT

-- Create an ext4 filesystem for our root partition
# mkfs.ext4 -L nixos /dev/nixos-vg/root

-- Tell our swap partition to be a swap
# mkswap -L swap /dev/nixos-vg/swap

-- Turn the swap on before install
# swapon /dev/nixos-vg/swap

# Mount partitions
mount /dev/nixos-vg/root /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot

# Generate config
nixos-generate-config --root /mnt

# Copy initial-config.nix to /etc/nixos/configuration.nix
# /!\ Save hardware-configuration.nix to this repo!

# Install
nixos-install

# Connect as user
su <User>

# Add channels
nix-channel --add https://nixos.org/channels/nixpkgs-unstable unstable; nix-channel --update
```

# Mount from live
```
cryptsetup luksOpen /dev/sda2 nixos-enc
lvscan
vgchange -ay
mount /dev/nixos-vg/root /mnt
swapon /dev/nixos-vg/swap
mount /dev/sda1 /mnt/boot
nixos-enter / nixos-install
```
