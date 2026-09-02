# Package scope

Parrot Drone Tools is a curated view of software already supplied by Parrot OS.
It adds a metapackage and a menu domain; it does not replace Parrot's repositories.

## Included domains

| Domain | Representative packages and workflows |
|---|---|
| SDR and RF | GNU Radio, Gqrx, SDR++, Inspectrum, rtl_433, SatDump and common SoapySDR backends |
| Remote ID foundations | Kismet wireless capture and the packaged AntSDR DJI DroneID helper |
| Telemetry | pymavlink, serial tooling and CAN/DroneCAN foundations |
| GNSS | GNSS-SDR, gpsd, GPSBabel, Viking and RTKLIB command-line tools |
| Airspace awareness | readsb, gr-air-modes and supporting capture/analysis tools |
| Firmware and hardware | Binwalk, Rizin, radare2, OpenOCD, flashrom, PulseView and programmer utilities |
| Computer vision foundations | OpenCV, ONNX Runtime, NumPy and portable CPU PyTorch by default |

The metapackage also recommends the radio backends and Kismet capture helpers
present in Parrot's archive. It does not claim that every protocol is decodable
over the air or that one receiver covers every drone band.

## Kept in existing Parrot domains

General-purpose tools stay where Parrot already organizes them:

| Need | Existing Parrot domain |
|---|---|
| Password recovery | `parrot-tools-password` |
| Full reverse-engineering suite | `parrot-tools-reversing` |
| Disk and memory forensics | `parrot-tools-forensics` |
| General network and web testing | `parrot-tools-sniff`, `parrot-tools-web` |

This avoids turning a focused drone toolbox into a second copy of Parrot's full
security edition.

## Baseline boundary

The project covers the Parrot-native toolbox and menu integration. Hardware
setup and the Damn Vulnerable Drone lab are documented and installed separately.
