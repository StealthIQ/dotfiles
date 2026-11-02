#!/usr/bin/env python3
"""Show every active Hyprland keybind in a searchable fuzzel list.

Keys come from `hyprctl binds -j`, so the list is always what Hyprland really
has loaded. Descriptions come from the Lua config: a trailing `-- comment`,
a `description = "..."` option, or the command itself as a fallback.
"""

import json
import re
import subprocess
from pathlib import Path

CONFIG_FILES = [
    Path.home() / ".config/hypr/custom/keybinds.lua",
    Path.home() / ".config/hypr/custom/private/init.lua",
    Path.home() / ".config/hypr/hyprland/keybinds.lua",
]
MOD_BITS = [(64, "SUPER"), (4, "CTRL"), (8, "ALT"), (1, "SHIFT")]
MOD_ORDER = {name: i for i, (_, name) in enumerate(MOD_BITS)}
BIND_START = re.compile(r'hl\.bind\(\s*"([^"]+)"')


def combo_key(text: str) -> tuple[frozenset[str], str]:
    """Normalise "SUPER + SHIFT + F" into ({SUPER, SHIFT}, "f")."""
    parts = [p.strip().upper() for p in text.split("+") if p.strip()]
    return frozenset(parts[:-1]), parts[-1].lower() if parts else ""


def statement_end(src: str, start: int) -> int:
    """Index just past the closing paren of the hl.bind( call at `start`."""
    depth, i, quote = 0, start, None
    while i < len(src):
        ch = src[i]
        if quote:
            if ch == "\\":
                i += 1
            elif ch == quote:
                quote = None
        elif ch in "\"'":
            quote = ch
        elif ch == "(":
            depth += 1
        elif ch == ")":
            depth -= 1
            if depth == 0:
                return i + 1
        i += 1
    return len(src)


def describe(body: str, tail: str) -> str:
    """Pick the best human-readable description for one bind."""
    if m := re.match(r"\s*--\s*(.+)", tail):
        return m.group(1).strip()
    if m := re.search(r'description\s*=\s*"([^"]+)"', body):
        return m.group(1)
    if m := re.search(r'global\("quickshell:([^"]+)"\)', body):
        return "Quickshell: " + re.sub(r"(?<!^)([A-Z])", r" \1", m.group(1)).lower()
    if m := re.search(r'exec_cmd\(\s*"((?:[^"\\]|\\.)*)"', body):
        return "Run: " + m.group(1).replace('\\"', '"')
    if m := re.search(r"hl\.dsp\.([a-z_.]+)\((.*)", body, re.S):
        return m.group(1).replace("window.", "window ") + " " + m.group(2)[:40].strip(" )")
    return "Lua function"


def parse_config() -> dict[tuple[frozenset[str], str], tuple[int, str]]:
    """Map each key combo to (order, description); first definition wins."""
    found: dict[tuple[frozenset[str], str], tuple[int, str]] = {}
    for path in CONFIG_FILES:
        try:
            src = path.read_text()
        except FileNotFoundError:
            continue
        except OSError as err:
            print(f"keybinds-cheatsheet: cannot read {path}: {err}")
            continue
        for m in BIND_START.finditer(src):
            if src[src.rfind("\n", 0, m.start()) + 1 : m.start()].lstrip().startswith("--"):
                continue
            end = statement_end(src, m.start() + len("hl.bind"))
            line_end = src.find("\n", end)
            tail = src[end : line_end if line_end != -1 else len(src)]
            key = combo_key(m.group(1))
            found.setdefault(key, (len(found), describe(src[m.end() : end], tail)))
    return found


def active_binds() -> list[tuple[frozenset[str], str, str]]:
    """Return (mods, key, label) for binds active outside submaps."""
    out = subprocess.run(["hyprctl", "binds", "-j"], capture_output=True, text=True, check=True)
    seen, result = set(), []
    for b in json.loads(out.stdout):
        if b.get("submap") or b.get("mouse") or not b.get("key"):
            continue
        mods = frozenset(name for bit, name in MOD_BITS if b["modmask"] & bit)
        ident = (mods, b["key"].lower())
        if ident in seen:
            continue
        seen.add(ident)
        result.append((mods, b["key"].lower(), b["key"]))
    return result


def main() -> None:
    """Build the list and show it in fuzzel."""
    if subprocess.run(["pkill", "-x", "fuzzel"]).returncode == 0:
        return  # second press closes the list
    descriptions = parse_config()
    rows = []
    for mods, key, label in active_binds():
        order, text = descriptions.get((mods, key), (10_000, "(no description)"))
        combo = " + ".join(sorted(mods, key=MOD_ORDER.get) + [label.upper() if len(label) == 1 else label])
        rows.append((order, f"{combo:<28}  {text}"))
    rows.sort()
    subprocess.run(
        ["fuzzel", "--dmenu", "--prompt", "Keybinds  ", "--width", "100", "--lines", "25", "--match-mode", "fzf"],
        input="\n".join(r for _, r in rows),
        text=True,
    )


if __name__ == "__main__":
    main()
