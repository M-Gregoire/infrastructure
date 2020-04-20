# Meshmixer

Unfortunately not native on Linux but allows to create awesome support, using less material and less destructive to the printed model.

# Tools

- [Bearing tool](https://www.thingiverse.com/thing:2430285)
- [Razor blade holder](https://www.thingiverse.com/thing:2271632)

# Printing tests and calibration

- [Calibration circle/cross](https://www.thingiverse.com/thing:119302)
- [Calibration cube](https://www.thingiverse.com/thing:1278865)

# BLTouch and Z offset calibration

The Z offet needs to be configured as the BLTouch is not (and should not) be installed to stop at exactly Z=0. To do so, see [here](https://3dprinting.stackexchange.com/questions/5857/z-offset-on-autoleveling-sensor-setup).

*Note:* M114 gives you current position.

You can also modify `#define Z_PROBE_OFFSET_FROM_EXTRUDER <offset>` accordingly. This way, If you reset your EEPROM with `M502` this setting is kept (Info on `EEPROM` can be found [here](https://github.com/MarlinFirmware/Marlin/wiki/EEPROM)).

You can now level the bed following [this](http://marlinfw.org/docs/features/auto_bed_leveling.html). You can modify your slicer config to run `G28` then `G29` to auto-level on every print.

When it's correctly working, springs can be removed thanks to [this](https://www.thingiverse.com/thing:2165389) upgrade.
