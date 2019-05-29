# Anet-A8
My settings for my Anet A8 3D printer

## Slic3r

Profile included in the folder.

## Octoprint

I use an Octoprint server running on a Raspberry Pi. I've installed the following plugins:

- Bed Level Visualizer (Install can take a long time, ~30min. This is a known issue. It might need to be run manually and not through plugin manager.) using:  
```
G28
M155 S30
@BEDLEVELVISUALIZER
G29 T
M155 S3

```
- EEPROM Marlin Editor
- Marlin flasher (Need to install `arduino-cli`, see [this](https://github.com/arduino/arduino-cli))
- OctoPrint-BLTouch
- OctoPrint-Slic3r (See [this](https://github.com/OctoPrint/OctoPrint-Slic3r/wiki/How-to-install-Slic3r-on-RPi))
- TabOrder to use icon in place of tab title

# Upgrades

## 3D printed

Spool holder :
https://www.thingiverse.com/thing:1624641

Extruder button :
https://www.thingiverse.com/thing:1935151

Filament guide :
https://www.thingiverse.com/thing:1764285

Center nozzle fan :
https://www.thingiverse.com/thing:1620630

Wing nut bed level x4 :
https://www.thingiverse.com/thing:2000216

M8 nut cap x2 :
https://www.thingiverse.com/thing:2357524

T-Corner :
https://www.thingiverse.com/thing:1672959

Extruder fan modification for easier access to extruder motor:
https://www.thingiverse.com/thing:2290361

Extruder filament guide for easier filament change :
https://www.thingiverse.com/thing:2327007

Mainboard cover :
https://www.thingiverse.com/thing:2013479

Bearing tool :
https://www.thingiverse.com/thing:2430285

Front frame brace :
https://www.thingiverse.com/thing:1857991

Rear frame brace :
https://www.thingiverse.com/thing:1852358

Y-belt tensioner :
https://www.thingiverse.com/thing:1959208

Razor blade holder :
https://www.thingiverse.com/thing:2271632

Z-Axis carriage :
https://www.thingiverse.com/thing:1919544

Tool holder :
https://www.thingiverse.com/thing:2072360
https://www.thingiverse.com/thing:2086689

Heatsink spacer :
https://www.thingiverse.com/thing:2387420

Y-axis cable chain :
https://www.thingiverse.com/thing:1874802
https://www.thingiverse.com/thing:2221564

Dual mosfet mount :
https://www.thingiverse.com/thing:2086107

X-axis cable chain :
https://www.thingiverse.com/thing:2115095

Power supply cover :
https://www.thingiverse.com/thing:2320216

## Not 3D printed

Changing Mosfets (~ 6€):
https://3dprint.wiki/reprap/electronics/heatbed_mosfet

Changing belt to fiber-glass reinforced ones. (~ 3€)

Replaced all the bearing with Igus DryLin RJ4JP-01-08 x11 (3 for extruder, 4 for hotbed and 4 for Z-axis.) (~ 20€)

Bought 608ZZ bearing for the anti-wobble (~ 2€)

Power Supply Socket Connector with Rocker Switch (~ 1€)

Glass print bed (~ 15€)

Total cost (except PLA filament) : ~ 47€.

# Bowden

## 3D printed
Extruder mount :
https://www.thingiverse.com/thing:2253855

Carriage :
https://www.thingiverse.com/thing:2668564

General guide :
https://www.thingiverse.com/thing:2268994

## Not 3D printed

E3D V6 Hot end + Titan extruder (~ 20-30$ for clone)

BL Touch (Optional) (~ 15$)

## Firmware upgrade

Using [marlin](http://marlinfw.org/) and [SkyNet3D](https://github.com/SkyNet3D/anet-board) board definition.

```
#define TEMP_SENSOR_0 5
#define HEATER_0_MAXTEMP 275
#define HEATER_0_MINTEMP 5
// Set extruder rate for pancake motor (42BYGH22 (1.8 degree))
#define DEFAULT_AXIS_STEPS_PER_UNIT   { 100, 100, 400, 418.5 }
// Adapt X home position for E3D carriage
#define X_MIN_POS -10
// Set PLA preheat to 215C and bed to 65C
// Note 215C for PLA is only for my first layer
#define PREHEAT_1_TEMP_HOTEND 215
#define PREHEAT_1_TEMP_BED     65
```

For the Titan extruder, I also had to set `#define INVERT_E0_DIR true` in order for the filament to go in the right direction.

When fine tuning steps:
```
//#define PREVENT_COLD_EXTRUSION
```

# Autotune

I've ran `M303 S200 C10` to start the autotune process for PLA(`M303` is the command, `S` specified the target temperature and `C` the number of times to repeat the process). Then, this is applied in my Marlin config with (Example):

```
  #define DEFAULT_Kp 21.0
  #define DEFAULT_Ki 1.25
  #define DEFAULT_Kd 86.0

```
You can also do the hotbed with `M303 S40 C3 E-1` (`E` specified the heating element, `-1` is hotbed, `0` is first hotend, `1` the second hotend...).  

*Note:* `#define PIDTEMPBED` must be uncommented to run this command. You will need to comment `BED_LIMIT_SWITCHING` to do so.  

This is saved with (Example):

```
  #define DEFAULT_bedKp 10.00
  #define DEFAULT_bedKi .023
  #define DEFAULT_bedKd 305.4
```

# BLTOUCH

To obtain the best results with my auto leveling sensor, here is my process:
1) Make hotend tip touch the hotbed
2) Install the sensor so that the tip of the BLTouch is above the hotbed by ~0.5mm (No need to be precise, offset will be configured later on)

Then, Marlin configuration is flashed:

```
#define BLTOUCH
#define SERVO0_PIN 27
#if ENABLED(BLTOUCH)
  //#define BLTOUCH_DELAY 375   // (ms) Enable and increase if needed
#endif

#define Z_MIN_PROBE_ENDSTOP_INVERTING false

#define AUTO_BED_LEVELING_BILINEAR

#define Z_SAFE_HOMING

#if ENABLED(Z_SAFE_HOMING)
  #define Z_SAFE_HOMING_X_POINT ((X_BED_SIZE) / 2)    // X point for Z homing when homing all axes (G28).
  #define Z_SAFE_HOMING_Y_POINT ((Y_BED_SIZE) / 2)    // Y point for Z homing when homing all axes (G28).
#endif

#define X_PROBE_OFFSET_FROM_EXTRUDER -50
#define Y_PROBE_OFFSET_FROM_EXTRUDER 0
# The bottom of the housing ofthe BLTouch (Not the tip!) should be 8.3mm above the hotend tip.
#define Z_PROBE_OFFSET_FROM_EXTRUDER 0

#define EEPROM_SETTINGS  

#define LEFT_PROBE_BED_POSITION 10
#define RIGHT_PROBE_BED_POSITION 175
#define FRONT_PROBE_BED_POSITION 10
#define BACK_PROBE_BED_POSITION 205

// Travel limits (mm) after homing, corresponding to endstop positions.
#define X_MIN_POS -15
#define Y_MIN_POS -10
#define Z_MIN_POS 0
#define X_MAX_POS 245
#define Y_MAX_POS 215
#define Z_MAX_POS 240

```

Finally, the Z offet then needs to be configured. To do so, see [here](https://3dprinting.stackexchange.com/questions/5857/z-offset-on-autoleveling-sensor-setup).

You can also modify `#define Z_PROBE_OFFSET_FROM_EXTRUDER <offset>` accordingly. This way, If you reset your EEPROM with `M502` this setting is kept (Info on `EEPROM` can be found [here](https://github.com/MarlinFirmware/Marlin/wiki/EEPROM)).

You can now level the bed following [this](http://marlinfw.org/docs/features/auto_bed_leveling.html). You can modify your slicer config to run `G28` then `G29` to auto-level on every print.

When it's correctly working, springs can be removed thanks to [this](https://www.thingiverse.com/thing:2165389) upgrade.

## Advanced config

This section discuss changes made to `Configuration_adv.h` 

- Enable Babystepping to easily find Z probe offset by uncommenting `#define BABYSTEPPING`.


# Upgrades you should not need
Anti-Z wobble :
https://www.thingiverse.com/thing:1858435

See https://www.youtube.com/watch?v=T9vI6DqAcmo

# Tools

https://www.thingiverse.com/thing:2271632

# Calibration

https://www.thingiverse.com/thing:119302
