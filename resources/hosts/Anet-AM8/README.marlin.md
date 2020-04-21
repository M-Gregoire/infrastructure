# Marlin configuration

For easier update, I use a local Marlin repo I rebase on the remote one.
I start from the default configuration for Anet A8 and make the following changes:

Configuration.h - Basics
```
#define STRING_CONFIG_H_AUTHOR "(Grégoire, Custom config)"
// MKS Gen 1.4
#define MOTHERBOARD BOARD_MKS_GEN_13

// TMC2130 config ("TMCStepper by teemuatlut" Library must be installed)
#define X_DRIVER_TYPE  TMC2130
#define Y_DRIVER_TYPE  TMC2130
#define Z_DRIVER_TYPE  TMC2130
#define E0_DRIVER_TYPE TMC2130
//#define ENDSTOP_INTERRUPTS_FEATURE

#define INVERT_X_DIR true
#define INVERT_Y_DIR true
#define INVERT_Z_DIR false

#define X_MIN_POS -10
#define Y_MIN_POS -10
#define Z_MIN_POS 0
#define X_MAX_POS X_BED_SIZE
#define Y_MAX_POS Y_BED_SIZE
#define Z_MAX_POS 240

// Titan Extruder config
// Set extruder rate for pancake motor (42BYGH22 (1.8 degree))
#define DEFAULT_AXIS_STEPS_PER_UNIT   { 100, 100, 400, 418.5 }
// Correct extrusion direction
#define INVERT_E0_DIR false
```

Configuration.h - BLTouch
```
#define BLTOUCH
#define NUM_SERVOS 1 // Servo index starts with 0 for M280 command
#define Z_SAFE_HOMING
#define NOZZLE_TO_PROBE_OFFSET { 50, 0, 0 }

#define AUTO_BED_LEVELING_BILINEAR

```

First, make sure `#define PIDTEMPBED` is not commented and `BED_LIMIT_SWITCHING` is commented.

For the hotend: I've ran `M303 S200 C10` to start the autotune process for PLA(`M303` is the command, `S` specified the target temperature and `C` the number of times to repeat the process).

For the bed: `M303 S60 C3 E-1` (`E` specified the heating element, `-1` is hotbed, `0` is first hotend, `1` the second hotend...).

Which should give you results you can set in Marlin.
Either by saving them in EEPROM with M500 and loading them with M501

Or by setting them as default with the following configuration. In my case:

Configuration.h - PID
```
#define DEFAULT_Kp 22.49
#define DEFAULT_Ki 1.68
#define DEFAULT_Kd 75.06
#define DEFAULT_bedKp 194.26
#define DEFAULT_bedKi 35.93
#define DEFAULT_bedKd 700.17
```

Configuration_adv.h
```
#define X_CS_PIN          2
#define Y_CS_PIN          1
#define Z_CS_PIN          57
#define E0_CS_PIN         58

// Use HE01 for E0 fan
#define E0_AUTO_FAN_PIN 7

// Used to find correct Z offset with BLTouch
#define BABYSTEPPING

// Enable M43 command
// Very useful for pin debugging
#define PINS_DEBUGGING
```
