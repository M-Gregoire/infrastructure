# Anet-A8
My settings and upgrades for my Anet A8 3D printer.

## Slic3r

Profile included in the folder.

## Meshmixer

Unfortunately not native on Linux but allows to create awesome support, using less material and less destructive to the printed model.

## Octoprint

I use an Octoprint server running on a Raspberry Pi. I've installed the following plugins:

- [OctoPrint-BedLevelVisualizer](https://github.com/jneilliii/OctoPrint-BedLevelVisualizer). I use the following commands:
```
G28
M155 S30
@BEDLEVELVISUALIZER
G29 T
M155 S3
```
- [OctoPrint-BLTouch](https://github.com/jneilliii/OctoPrint-BLTouch)
- [OctoPrint-DisplayProgress](https://github.com/OctoPrint/OctoPrint-DisplayProgress)
- [OctoPrint-EEPROM-Marlin](https://github.com/amsbr/OctoPrint-EEprom-Marlin)
- [OctoPrint-FilamentManager](https://github.com/malnvenshorn/OctoPrint-FilamentManager) and [OctoPrint-CostEstimation](https://github.com/malnvenshorn/OctoPrint-CostEstimation)
- [OctoPrint-Fullscreen](https://github.com/BillyBlaze/OctoPrint-FullScreen)
- [OctoPrint-MQTT](https://github.com/OctoPrint/OctoPrint-MQTT/) and [OctoPrint-MQTTPublish](https://github.com/jneilliii/OctoPrint-MQTTPublish)
- [OctoPrint-Marlin-Flasher](https://github.com/Renaud11232/OctoPrint-Marlin-Flasher) (Need to install `arduino-cli`, see [this](https://github.com/arduino/arduino-cli))
- [OctoPrint-PrintTimeGenius](https://github.com/eyal0/OctoPrint-PrintTimeGenius)
- [OctoPrint-Slic3r](https://github.com/OctoPrint/OctoPrint-Slic3r) (See [this](https://github.com/OctoPrint/OctoPrint-Slic3r/wiki/How-to-install-Slic3r-on-RPi))
- [OctoPrint-TabOrder](https://github.com/jneilliii/OctoPrint-TabOrder) to change tabs to icons
- [OctoPrint-WebcamTab](https://github.com/malnvenshorn/OctoPrint-WebcamTab)
- [Octolapse](https://github.com/FormerLurker/Octolapse)


### Install command
``` bash
/home/pi/oprint/bin/pip install \
	https://github.com/jneilliii/OctoPrint-BedLevelVisualizer/archive/master.zip \
	https://github.com/jneilliii/OctoPrint-Bltouch/archive/master.zip \
	https://github.com/OctoPrint/OctoPrint-DisplayProgress/archive/master.zip \
	https://github.com/amsbr/OctoPrint-EEPROM-Marlin/archive/master.zip \
	https://github.com/malnvenshorn/OctoPrint-FilamentManager/archive/master.zip https://github.com/malnvenshorn/OctoPrint-CostEstimation/archive/master.zip \
	https://github.com/BillyBlaze/OctoPrint-FullScreen/archive/master.zip \
    https://github.com/OctoPrint/OctoPrint-MQTT/archive/master.zip https://github.com/jneilliii/OctoPrint-MQTTPublish/archive/master.zip \
	https://github.com/Renaud11232/Octoprint-Marlin-Flasher/archive/master.zip \
	https://github.com/eyal0/OctoPrint-PrintTimeGenius/archive/master.zip \
	https://github.com/OctoPrint/OctoPrint-Slic3r/archive/master.zip \
	https://github.com/jneilliii/OctoPrint-TabOrder/archive/master.zip \
	https://github.com/malnvenshorn/OctoPrint-WebcamTab/archive/master.zip \
	https://github.com/FormerLurker/Octolapse/archive/master.zip
```

*Warning*: You need to manually:
- Install `arduino-cli` for `Octoprint-Marlin-Flasher`
- Follow the documentation of `Octoprint-Slic3r` to configure it
- Configure `Octoprint-BedLevelVisualizer`

# Upgrades

## General improvements

- [Mainboard cover](https://www.thingiverse.com/thing:2013479)

- [Anet A8 X-Carriage Mounts](https://www.thingiverse.com/thing:1919544)

- [X-axis cable chain](https://www.thingiverse.com/thing:2115095)

- [Y-axis cable chain](https://www.thingiverse.com/thing:1874802) and a [Bed protector](https://www.thingiverse.com/thing:2221564)

- [Dual mosfet mount](https://www.thingiverse.com/thing:2086107)


## Moving to Bowden

I replaced the stock hotend + extruder by an E3D V6 clone and a Titan extruder. To do so, I printed these:

- [Extruder mount](https://www.thingiverse.com/thing:2253855)
- [Carriage](https://www.thingiverse.com/thing:2668564)

I later moved to this carriage:
https://www.thingiverse.com/thing:2748650
which has the benefit of having the BLTouch at a fixed height.

I also followed this [General guide](https://www.thingiverse.com/thing:2268994).

The changes made to the firmware are detailled further in this readme.

## Having multiple nozzle size

Playing with nozzle size allows for much more control!

## Adding a autoleveling sensor

I bought an BLTouch, installed it on the carriage printed for the E3D V6 hotend and modified the firmware accordingly (Detailled further).

## Changing Mosfets

For safety, see [this](https://3dprint.wiki/reprap/electronics/heatbed_mosfet).

## Changing belts

Using fiber-glass reinforced belt is cheap and much more durable.

## Replaced the bearing

Some bearing I received with the stock Anet were defective, the rest was just bad. I changed them for Igus DryLin RJ4JP-01-08 x11 (3 for extruder, 4 for hotbed and 4 for Z-axis.)

## Added fused switch to power supply

Added a Power Supply Socket Connector with Rocker Switch with [this](https://www.thingiverse.com/thing:2320216) design.

## Changing hotend fan

For silence, using a 40mm Noctua Fan with [this](https://www.thingiverse.com/thing:2748800/comments) adapter.

## Changing the motherboard and stepper drivers

I've changed the original motherboard to an MKS Gen 1.4 with TMC2130 SPI stepper drivers.

## Changing the heat bed

I've replaced the original heat bed by an aluminium place with a silicon heating pad and a glass plate on top. The bed is insulated by a sheet of cork. The silicon heating pad is controlled by an SSR.

## Filament sensor

Add a sensor to detect if the filament as run out. In this case, the print is paused.

## Moving to AM8

This is by far the biggest upgrade I made. This is based on this [guide](https://www.thingiverse.com/thing:2263216).
The build guide is very detailled.


# Firmware changes

In order to customize the firmware on the motherboard, I used [marlin](http://marlinfw.org/). If the original Anet A8 motherboard is used, then [SkyNet3D](https://github.com/SkyNet3D/anet-board) board definition is required. The modified files (`Configuration.h` and `Configuration_adv.h`) are included in this folder.


# Original Anet A8 screen on RAMPS

/!\ GND and 5V needs to be inverted
https://www.thingiverse.com/groups/anet-a6/forums/general/topic:27555#comment-1759843

## General configuration
```
#define HEATER_0_MAXTEMP 275
#define HEATER_0_MINTEMP 5
// Set PLA preheat to 215C and bed to 65C
// Note 215C for PLA is only for my first layer
#define PREHEAT_1_TEMP_HOTEND 215
#define PREHEAT_1_TEMP_BED     65
```

## E3D V6 hotend + Titan extruder

```
#define TEMP_SENSOR_0 5
// Set extruder rate for pancake motor (42BYGH22 (1.8 degree))
#define DEFAULT_AXIS_STEPS_PER_UNIT   { 100, 100, 400, 418.5 }
// Adapt X home position for E3D carriage
#define X_MIN_POS -10
// Correct extrusion direction
#define INVERT_E0_DIR true
```

When fine tuning steps, I also changed:
```
//#define PREVENT_COLD_EXTRUSION
```

## Autotune PID

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

## BLTOUCH

Wiring not detailled here as there are plenty of good resources. Hardest part is probably to find the correct wire to cut from the LCD screen. It's the 3rd, counting from the red one.

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

This section discuss changes made to `Configuration_adv.h` (included in this folder).

- Enable Babystepping to easily find Z probe offset by uncommenting `#define BABYSTEPPING`.

# Tools

- [Bearing tool](https://www.thingiverse.com/thing:2430285)
- [Razor blade holder](https://www.thingiverse.com/thing:2271632)

# Calibration

- [Calibration circle/cross](https://www.thingiverse.com/thing:119302)
- [Calibration cube](https://www.thingiverse.com/thing:1278865)

# Outdated upgrades

## 3D printed for the Anet A8

These are the upgrades I 3D printed for the Anet A8 version. They became useless when I moved to an Anet AM8:

- [Spool holder](https://www.thingiverse.com/thing:1624641)
- [Filament guide](https://www.thingiverse.com/thing:1764285)
- [M8 nut cap](https://www.thingiverse.com/thing:2357524) x2
- [T-corner](https://www.thingiverse.com/thing:1672959)
- [Front frame brace](https://www.thingiverse.com/thing:1857991)
- [Rear frame brace](https://www.thingiverse.com/thing:1852358)
- [Y-belt tensioner](https://www.thingiverse.com/thing:1959208)
- [Tool holder (Left)](https://www.thingiverse.com/thing:2072360)
- [Tool holder (Right)](https://www.thingiverse.com/thing:2086689)

## 3D printer for stock extruder/hotend

These are the upgrades I 3D printed for the original extruder and hotend. I then moved to an E3D V6 hotend with a Titan extruder.

- [Extruder button](https://www.thingiverse.com/thing:1935151)
- [Extruder fan modification](https://www.thingiverse.com/thing:2290361) for easier access to extruder motor
- [Extruder filament guide](https://www.thingiverse.com/thing:2327007) for easier filament change
- [Heatsink spacer](https://www.thingiverse.com/thing:2387420)

## 3D printed for original heat bed

These where printed for the origin heat bed. I since changed it for a aluminium plate with a silicon heater pad and a glass plate on top.

- [Wing nut bed level](https://www.thingiverse.com/thing:2000216) x4


# Upgrades you should not need
- [Anti-Z wobble](https://www.thingiverse.com/thing:1858435)

See https://www.youtube.com/watch?v=T9vI6DqAcmo
