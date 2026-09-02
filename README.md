# Parrot Drone Tools

Turn a standard Parrot OS 7 desktop into a drone and UAV security workstation
using packages already present in Parrot's archive.

This project installs the `parrot-tools-drone` metapackage and adds a native
**Drone & UAV** application-menu domain. It does not install hardware drivers,
configure radios, modify graphics drivers, or reproduce a particular machine.

## Status

The installer is under development. The package and menu payload were validated
on Parrot 7.3 amd64 and arm64 as part of the original Parrot Drone Edition work.
The compatibility package currently bundled for `python3-pymavlink` is amd64
only, so the first standalone installer release targets amd64.

## Install

Clone or download a release, then run:

```bash
sudo ./install.sh
```

The default installation uses Parrot's own package archive. Suggested packages
are not installed automatically.

Verify an installation at any time:

```bash
./verify.sh
```

Remove the menu integration and metapackage with:

```bash
sudo ./uninstall.sh
```

Removing the metapackage does not automatically remove tools that APT installed
with it.

## Scope

The toolbox covers SDR and RF analysis, Remote ID foundations, MAVLink and
DroneCAN telemetry, GNSS, airspace awareness, firmware analysis, and common
radio backends. See [docs/PACKAGE-SCOPE.md](docs/PACKAGE-SCOPE.md).

Damn Vulnerable Drone is deliberately separate because it is large, niche, and
intentionally vulnerable. Hardware and GPU setup are outside this project's
scope.

## License

GPL-3.0-or-later.
