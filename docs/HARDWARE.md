# Hardware notes

No SDR, drone, radio, or GPU is required to install Parrot Drone Tools. The
installer does not probe for hardware and does not alter drivers or firmware.

## Match the receiver to the job

Drone work commonly spans several bands:

| Band | Typical relevance |
|---|---|
| 868/915 MHz | Regional telemetry, LoRa-family links and some long-range control systems |
| 2.4 GHz | Wi-Fi, Bluetooth Remote ID and many control links |
| 5.8 GHz | FPV video and wideband proprietary links |

Coverage in one row does not imply coverage in another. Receiver tuning range,
instantaneous bandwidth and antenna coverage all matter. A wide-tuning radio
with the wrong antenna is still the wrong setup.

The archive-native toolbox includes backends for several common SDR families,
but this repository neither endorses one device nor promises that a packaged
backend implements every proprietary drone protocol.

## What the installer leaves alone

- USB permissions outside normal package behavior
- Device firmware
- Wi-Fi interface modes
- Kernel modules and DKMS
- Secure Boot
- NVIDIA and CUDA
- Monitor and desktop configuration

Users should follow their hardware vendor's documentation and Parrot's own
system documentation for those tasks.
