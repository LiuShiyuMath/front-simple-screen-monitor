# MacAir M1 Login

This doc records how agents and humans should connect from the Mac mini to the
MacAir M1 safely.

## What Changed

The project now documents the safe login path for the MacAir M1 target:

- Tailscale host: `m1macbook-air`
- Login user: `m1`
- Recommended alias: `macair-m1`
- Preferred auth: SSH public key
- Passwords must be typed interactively only and must not be committed, logged,
  or stored in project files.

## How To Run

Use the direct Tailscale SSH target:

```bash
ssh m1@m1macbook-air
```

Optional local SSH config on the Mac mini:

```sshconfig
Host macair-m1
    HostName m1macbook-air
    User m1
    PubkeyAuthentication yes
    PreferredAuthentications publickey,password,keyboard-interactive
```

Then connect with:

```bash
ssh macair-m1
```

## Safe Key Setup

Prefer key-based login. From the Mac mini, install the current public key on the
MacAir M1 with an interactive password prompt:

```bash
cat ~/.ssh/id_ed25519.pub | ssh m1@m1macbook-air \
  'mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys'
```

Do not use `sshpass`, do not write the password into shell history, and do not
add passwords to docs, scripts, environment files, or git-tracked files.

## How To Verify

Check that Tailscale sees the MacAir M1:

```bash
tailscale status | grep m1macbook-air
```

After key setup, verify non-interactive SSH:

```bash
ssh -o BatchMode=yes m1@m1macbook-air hostname
```

Expected result: the command prints the MacAir hostname and exits with status 0.

## Current Status

Status: `DOCUMENTED_SAFE_LOGIN_PATH`.

Password login has been observed to work manually for `m1@m1macbook-air`.
Project docs intentionally do not record the password. Key-based login should be
used for agent automation before running remote commands.
