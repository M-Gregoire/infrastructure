# Octoprint

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
