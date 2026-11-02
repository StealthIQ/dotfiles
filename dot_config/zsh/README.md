# Zsh Configuration - Migrated from Fish

This directory contains a complete Zsh configuration migrated from Fish shell, designed for use with Oh My Zsh.

## Directory Structure

```
zsh/
├── .zshrc              # Main configuration file
├── .zshenv             # Environment variables (sets ZDOTDIR)
├── conf.d/             # Modular configuration files (auto-loaded)
│   ├── 00-env.zsh      # Environment variables
│   ├── 01-path.zsh     # PATH configuration
│   ├── 20-tools.zsh    # External tool initializations
│   ├── 30-abbr.zsh     # Abbreviations/aliases
│   ├── 40-alias.zsh    # Aliases
│   ├── 50-functions.zsh # Custom functions
│   └── 99-host.zsh     # Host-specific config loader
├── completions/        # Zsh completions
├── functions/          # Custom functions (loaded as autoload)
├── host/               # Host-specific configurations
│   ├── stealthiq.zsh   # Interactive config
│   └── stealthiq.env.zsh # Environment variables
└── lib/                # Library files (for future use)
```

## Installation

### Step 1: Install Oh My Zsh

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### Step 2: Install Required Dependencies

Ensure you have these tools installed (they were in your Fish config):

```bash
# Arch Linux
sudo pacman -S starship zoxide fzf eza trash-cli yazi xclip

# For paru (AUR helper)
yay -S paru  # or install from AUR
```

### Step 3: Symlink Configuration

**Option A: Standard Installation (Recommended)**

```bash
# Backup existing zsh config if any
mv ~/.zshrc ~/.zshrc.backup 2>/dev/null

# Create symlink
ln -s ~/.config/zsh/.zshrc ~/.zshrc

# Optional: Also symlink .zshenv for XDG compliance
ln -s ~/.config/zsh/.zshenv ~/.zshenv
```

**Option B: XDG Base Directory Compliance (Advanced)**

If you want full XDG compliance, only symlink `.zshenv`:

```bash
ln -s ~/.config/zsh/.zshenv ~/.zshenv
```

This will automatically set `ZDOTDIR` and load the rest from `~/.config/zsh/`.

### Step 4: Install Optional Plugins

#### For Abbreviation Support (Fish-like behavior)

Fish abbreviations expand as you type; Zsh aliases don't. To get Fish-like abbreviations:

```bash
git clone https://github.com/olets/zsh-abbr ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-abbr
```

Then add `zsh-abbr` to the plugins array in `.zshrc`.

#### Other Recommended Plugins

```bash
# zsh-syntax-highlighting (Fish-like syntax highlighting)
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# zsh-autosuggestions (Fish-like autosuggestions)
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Add to plugins array in .zshrc:
# plugins=(... zsh-abbr zsh-syntax-highlighting zsh-autosuggestions)
```

### Step 5: Change Default Shell

```bash
chsh -s $(which zsh)
```

Then log out and back in, or start a new zsh shell:

```bash
zsh
```

## Migration Notes

### What's Changed

| Fish Feature | Zsh Equivalent | Notes |
|-------------|----------------|-------|
| `set -gx VAR value` | `export VAR=value` | Direct replacement |
| `fish_add_path PATH` | Custom `path_add` function | Added to `01-path.zsh` |
| `abbr -a name cmd` | `alias name='cmd'` | Or install `zsh-abbr` plugin |
| `function name; ...; end` | `function name() { ... }` | Standard POSIX syntax |
| `if test ...` | `if [[ ... ]]` | Zsh supports `[[` for better matching |
| `$argv` | `$@` | All arguments |
| `$argv[1]` | `$1` | First argument |
| `string lower` | `${var,,}` | Zsh parameter expansion |
| `switch/case` | `case/esac` | Standard POSIX syntax |
| `complete -c cmd` | `compdef` | Zsh completion system |

### Key Differences from Fish

1. **No universal variables**: Zsh doesn't have universal variables like Fish. Use `export` for environment variables.

2. **No abbreviations by default**: Fish abbreviations expand as you type. In Zsh, use the `zsh-abbr` plugin for this behavior.

3. **Manual completion loading**: Zsh completions need to be registered with `compdef` and added to `$fpath`.

4. **Quote handling**: Zsh is more strict about quote handling in aliases. Multi-word aliases should use single quotes.

5. **Glob patterns**: Zsh has more powerful globbing. You may need to quote patterns that were unquoted in Fish.

## Troubleshooting

### Completions not working

Ensure completions are loaded:

```bash
autoload -Uz compinit
compinit
```

This is already done in `.zshrc`.

### Commands not found

Check that PATH is set correctly:

```bash
echo $PATH
```

### Aliases not working

Zsh aliases don't expand in scripts or certain contexts. Use functions instead for complex behavior.

### Key bindings not working

Key sequences vary by terminal. To find the correct sequence:

```bash
# Press Ctrl+V then the key you want to bind
cat -v
```

Then use that sequence in `bindkey`.

## Going Back to Fish

Your Fish configuration remains untouched at `~/.config/fish/`. To switch back:

```bash
chsh -s $(which fish)
```

Then log out and back in.

## Customization

### Adding New Configurations

Create new files in `conf.d/` following the naming convention:

- `XX-descriptive-name.zsh` where `XX` is a two-digit number for load order
- Lower numbers load first

### Adding Functions

Add to `conf.d/50-functions.zsh` or create individual files in `functions/`.

### Adding Host-Specific Config

Add files to `host/`:

- `hostname.env.zsh` for environment variables (loaded first)
- `hostname.zsh` for interactive settings (loaded in interactive shells)

## References

- [Oh My Zsh Documentation](https://github.com/ohmyzsh/ohmyzsh/wiki)
- [Zsh Manual](https://zsh.sourceforge.io/Doc/Release/)
- [Zsh Guide](http://zsh.sourceforge.io/Guide/)
- [Fish to Zsh Migration Guide](https://www.oilshell.org/blog/2019/01/18.html)
