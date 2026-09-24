# Release package

The only bundled package is `parrot-tools-drone_7.4.0_amd64.deb`.
Its Debian source is under `packaging/`.

SHA-256:

```text
0b19c24fa6a4fb6733917828c839d6502bf83c87583588361bc02e6bb3fdbd5a  parrot-tools-drone_7.4.0_amd64.deb
```

The installer gets `python3-pymavlink` directly from Parrot's archive.
Version `2.4.37-0parrot2` removes the obsolete `python3-future` dependency
and supersedes our former `2.4.37-0parrot1+drone1` compatibility build.
The metapackage's tool selection is unchanged, so it remains at 7.4.0.

The old compatibility binary, patch, and rebuild instructions remain available
in Git history; they are no longer part of the installation.
