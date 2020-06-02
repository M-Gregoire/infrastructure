# Hardware

Compilation of the majority of hardware changes I made to the printer (In random order). Most of them are independant of whether this is an Anet A8 or Anet AM8 (Or any other custom printer for that matter).

## Moving to Bowden

I replaced the stock hotend + extruder by an E3D V6 clone and a Titan extruder. To do so, I printed these:

- [Extruder mount](https://www.thingiverse.com/thing:2253855)
- [Carriage](https://www.thingiverse.com/thing:2668564)

I later moved to this carriage:
https://www.thingiverse.com/thing:2748650
which has the benefit of having the BLTouch at a fixed height (with [this](https://www.thingiverse.com/thing:3060055) arm because the original hit the fan fuct).

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

### Original Anet A8 screen on RAMPS

/!\ GND and 5V needs to be inverted
https://3dprinting.stackexchange.com/questions/6030/connecting-anet-a8-2004-display-to-mks-gen-l
https://www.thingiverse.com/groups/anet-a6/forums/general/topic:27555#comment-1759843

## Changing the heat bed

I've replaced the original heat bed by an aluminium place with a silicon heating pad and a glass plate on top. The bed is insulated by a sheet of cork. The silicon heating pad is controlled by an SSR.

## Filament sensor

Add a sensor to detect if the filament as run out. In this case, the print is paused.
