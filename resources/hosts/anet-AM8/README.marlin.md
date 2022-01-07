# Marlin configuration

For easier update, I use a local Marlin repo I rebase on the remote one.
I start from the default configuration for Anet A8 and make the following changes:

Configuration.h - Basics
```
#define STRING_CONFIG_H_AUTHOR "(Grégoire, Custom config)"
// MKS Gen 1.4
#define MOTHERBOARD BOARD_MKS_GEN_13

// Baudrate
#define BAUDRATE 115200

// Name
#define CUSTOM_MACHINE_NAME "Anet A8"

// Filament
#define DEFAULT_NOMINAL_FILAMENT_DIA 1.75

// Temp
#define TEMP_SENSOR_0 5
#define TEMP_SENSOR_BED 5
#define BED_MAXTEMP      130

// Pid
// ANET A8 Standard Extruder at 210 Degree Celsius and 100% Fan
//(measured after M106 S255 with M303 E0 S210 C8)
#define DEFAULT_Kp 21.0
#define DEFAULT_Ki 1.25
#define DEFAULT_Kd 86.0

#define PIDTEMPBED
// ANET A8
// original Bed + 0.3mm Heat conducting into 4mm borosilicate (PID-Autotune: M303 E-1 S60 C5):
#define DEFAULT_bedKp 295.00
#define DEFAULT_bedKi 35.65
#define DEFAULT_bedKd 610.21

// Pos
#define X_MIN_ENDSTOP_INVERTING true  // Set to true to invert the logic of the endstop.
#define Y_MIN_ENDSTOP_INVERTING true  // Set to true to invert the logic of the endstop.
// Needed for BLTOUCH
#define Z_MIN_ENDSTOP_INVERTING false  // Set to true to invert the logic of the endstop.
#define Z_MIN_PROBE_ENDSTOP_INVERTING false  // Set to true to invert the logic of the probe.

// TMC2130 config ("TMCStepper by teemuatlut" Library must be installed)
#define X_DRIVER_TYPE  TMC2130
#define Y_DRIVER_TYPE  TMC2130
#define Z_DRIVER_TYPE  TMC2130
#define E0_DRIVER_TYPE TMC2130

// Octoprint
#define HOST_ACTION_COMMANDS

// Anet Config
#define DEFAULT_MAX_FEEDRATE          { 400, 400, 8, 50 }
#define DEFAULT_MAX_ACCELERATION      { 2000, 2000, 100, 10000 }
#define DEFAULT_ACCELERATION          400     // X, Y, Z and E acceleration for printing moves
#define DEFAULT_RETRACT_ACCELERATION  1000    // E acceleration for retracts
#define DEFAULT_TRAVEL_ACCELERATION   1000    // X, Y, Z acceleration for travel (non printing) moves


#define INVERT_X_DIR true
#define INVERT_Y_DIR true
#define INVERT_Z_DIR false

#define X_BED_SIZE 220
#define Y_BED_SIZE 220
#define X_MIN_POS 0
#define Y_MIN_POS 0
#define Z_MIN_POS 0
#define X_MAX_POS X_BED_SIZE
#define Y_MAX_POS Y_BED_SIZE
#define Z_MAX_POS 240

// Titan Extruder config
// Set extruder rate for pancake motor (42BYGH22 (1.8 degree))
#define DEFAULT_AXIS_STEPS_PER_UNIT   { 100, 100, 400, 429 }
// Correct extrusion direction
#define INVERT_E0_DIR true

// Persistent EEPROM
#define EEPROM_SETTINGS       // Persistent storage with M500 and M501

```

Configuration.h - BLTouch
```
#define BLTOUCH
//#define NUM_SERVOS 1 // Servo index starts with 0 for M280 command
#define Z_SAFE_HOMING
// Z Offset manually configured
#define NOZZLE_TO_PROBE_OFFSET { 40, 0, 0 }
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
 #define X_CS_PIN          63
 #define Y_CS_PIN          40
 #define Z_CS_PIN          42
 #define E0_CS_PIN         65

 #define TMC_USE_SW_SPI
 #define TMC_SW_MOSI       51
 #define TMC_SW_MISO       50
 #define TMC_SW_SCK        52

// Use HE01 for E0 fan
#define E0_AUTO_FAN_PIN 7

// Used to find correct Z offset with BLTouch
#define BABYSTEPPING

// Enable M43 command
// Very useful for pin debugging
#define PINS_DEBUGGING

// My steppers motor are rated for 0.9A
// To get the RMS value, we divide by 1.41
// So we should setup marlin to use 0.600A (To keep some margin)
// Note: Value is in mA
#define X_CURRENT       600
#define Y_CURRENT       600
#define Z_CURRENT       600
#define E0_CURRENT       600

```
