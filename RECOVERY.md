# 🔐 Recovery & Security Guide

This document outlines how to maintain and recover your secured dotfiles environment.

## 🔑 Key Management

Your encryption key is the most critical component.
- **Location**: `~/.config/age/key.txt`
- **Backup**: You MUST store this key in a secure location (e.g., Bitwarden, physical paper, encrypted vault). 
- **Lost Key**: If you lose this key, you lose access to all encrypted files in this repository (e.g., `opencode.json`).

## 🛠️ Machine Bootstrap

To setup a new machine:
1. Install `chezmoi` and `age`.
2. Restore your `key.txt` to `~/.config/age/key.txt`.
3. Run `chezmoi init https://github.com/StealthIQ/dotfiles`.
4. Run `chezmoi apply`.

## 🤖 Automation Safety

Automation timers are currently **DISABLED** for safety following a recovery event.
To re-enable them after verifying your local state:
```bash
systemctl --user enable --now chezmoi-pull.timer
systemctl --user enable --now chezmoi-push.timer
```

**Note**: The `--force` flag was removed from the pull service. It will now fail if there are local conflicts, allowing you to manually resolve them instead of losing work.

## 🛡️ Security Checks

- **Pre-push**: A local git hook scans for plaintext secrets before every push.
- **CI**: A GitHub Action runs on every push to verify no secrets are committed to the remote.
- **Encryption**: Sensitive files are stored with the `.age` extension in the source repository.
