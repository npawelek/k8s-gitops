# ESPHome-related devices

## Shelly

### Shelly 1

![shelly1 pinout](docs/shelly1_pinout.jpeg)

### Shelly 1PM

In the current implmentation of Shelly 1PM, it wasn't feasible to bridge the GPIO pins to obtain these readings ([Amp/Voltage Thread](https://github.com/arendst/Tasmota/issues/5716)). Shelly mentioned they planned to get in the future, but that has yet to happen.

### Shelly 2.5

![shelly25 pinout](docs/shelly25_pinout.jpeg)

## Sensors

### Xiaomi LYWSD03MMC (Temp and Humidity)

Flashed with the custom [pvvx firmware](https://github.com/pvvx/ATC_MiThermometer).

[Firmware flashing page](https://pvvx.github.io/ATC_MiThermometer/TelinkMiFlasher.html)

Settings configured as follows:
- Temperature: `F`
- Comfort
- Show battery
- Advertising type: `Custom` (default intervals)
- RF TX Power: `VANT +3.01 dbm`
- Minimum LCD refresh rate: `12.75`s (longest configurable)
- Comfort parameters:
  - Temp low: `20.00`
  - Temp high: `22.77`
