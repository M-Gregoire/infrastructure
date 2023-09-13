# Use device tree overlay

Get the `dts` file of your overlay, or the compiled version in `dtb` (or `dtbo`).

https://github.com/raspberrypi/firmware/tree/master/boot/overlays
https://github.com/raspberrypi/linux/tree/rpi-6.1.y/arch/arm/boot/dts/overlays

If you have the `dtb` (or `dtbo`), convert it to `dts` using:
```
dtc -I dtb -O dts input.dtbo -o output.dts
```

Got
```
DTOVERLAY[error]: can't find symbol 'spi0_cs_pins'
```
because it needs Raspberry pi kernel:
https://github.com/raspberrypi/linux/issues/3846#issuecomment-899571413

From the [documentation](https://nixos.wiki/wiki/NixOS_on_ARM/Raspberry_Pi)
```
By default NixOS uses the official Linux kernel released by kernel.org (a "mainline" kernel, e.g. pkgs.linuxPackages). This works fine on a Raspberry Pi, and is the better-tested option.

It is also possible to use a kernel released by the Raspberry Pi Foundation (a "vendor" kernel, e.g. pkgs.linuxPackages_rpi3). This may be preferable if you're using an add-on board that the mainline kernel does not have drivers for.

You can select your kernel by setting boot.kernelPackages. 
```



## Resources
https://docs.kernel.org/devicetree/overlay-notes.html
https://github.com/NixOS/nixos-hardware/blob/master/raspberry-pi/4/apply-overlays-dtmerge.nix


## Related issues
https://github.com/NixOS/nixpkgs/issues/125354

