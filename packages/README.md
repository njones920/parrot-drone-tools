# Release packages

Release archives contain two verified packages here:

- `parrot-tools-drone_7.3.0_amd64.deb`
- `python3-pymavlink_2.4.37-0parrot1+drone1_amd64.deb`

SHA-256:

```text
65d3ced660b1cad996b534913cf0e3c356c17b45715d6aaa556667b88a45b4bc  parrot-tools-drone_7.3.0_amd64.deb
b7cb7f1630a0018f52811aa1c5cbc702a35bf3725cfab616733a9db65833b834  python3-pymavlink_2.4.37-0parrot1+drone1_amd64.deb
```

The metapackage source is under `packaging/`. The pymavlink compatibility patch
is under `patches/`; it removes Parrot's obsolete Python 2 `future` dependency.
