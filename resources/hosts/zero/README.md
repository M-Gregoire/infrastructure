# Zero

## Installation

Through `rpi-imager`, headless using advanced config.

## Configuration

``` sh
sudo apt update && sudo apt upgrade -y && sudo apt install tvheadend vim
vim /etc/default/tvheadend
# Add `--http_port 80` to OPTIONS
sudo setcap 'cap_net_bind_service=+ep' /usr/bin/tvheadend
sudo systemctl restart tvheadend
```
