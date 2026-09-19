# Release packages

Release archives contain two verified packages here:

- `parrot-tools-drone_7.4.0_amd64.deb`
- `python3-pymavlink_2.4.37-0parrot1+drone1_amd64.deb`

SHA-256:

```text
0b19c24fa6a4fb6733917828c839d6502bf83c87583588361bc02e6bb3fdbd5a  parrot-tools-drone_7.4.0_amd64.deb
b7cb7f1630a0018f52811aa1c5cbc702a35bf3725cfab616733a9db65833b834  python3-pymavlink_2.4.37-0parrot1+drone1_amd64.deb
```

The metapackage source is under `packaging/`. The pymavlink compatibility patch
is under `patches/`; it removes Parrot's obsolete Python 2 `future` dependency.

## Rebuild the pymavlink compatibility package

Use Parrot 7.x on amd64 with the matching `deb-src` entry enabled for the
`echo main` archive. Install `build-essential`, `devscripts`, and `patch`, and
refresh APT metadata first. Run the following from the repository root; build
artifacts stay in a temporary directory.

```bash
repo_dir="$PWD"
build_dir=$(mktemp -d /tmp/parrot-pymavlink-build.XXXXXX)
cd "$build_dir"
apt-get source pymavlink=2.4.37-0parrot1
cd pymavlink-2.4.37

patch --fuzz=0 --forward -p1 \
  -i "$repo_dir/patches/pymavlink-drop-python-future-dependency.patch"

# Use the patched control file: the archive's build-dep still requires future.
sudo apt-get build-dep .
dpkg-checkbuilddeps
DEBFULLNAME='Nate Jones' DEBEMAIL='njones920@gmail.com' \
  dch --newversion 2.4.37-0parrot1+drone1 --distribution parrot \
  --force-distribution 'Drop python3-future from build and runtime dependencies.'
dpkg-buildpackage -b -us -uc
```

The patch includes the Debian `Build-Depends` change as well as the Python
source and metadata changes. Keep its mixed line endings intact: the upstream
`tools/mavtelemetry_datarates.py` file uses CRLF.

The resulting package is in `$build_dir`. Check its `Depends` with `dpkg-deb -f`
and test it before replacing the bundled binary. A rebuild can have a different
checksum because the changelog, timestamps, and build tools differ. If replacing
a bundled package, update both `SHA256SUMS` and the hashes above.
