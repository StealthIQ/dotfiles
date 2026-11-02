# Neovim Formatter Setup Guide

This guide walks you through installing and configuring formatters for your Neovim setup. It covers both Node.js-based and system-level formatters to ensure consistent code formatting across various languages.

## Step 1: Install Formatters

### 1.1 Node.js-based Formatters (Global Installation)

Install Prettier globally for JavaScript/TypeScript and other web technologies:

```bash
npm install -g prettier
```

**Supported file types:**
- JavaScript/TypeScript: `.js`, `.ts`, `.jsx`, `.tsx`
- Configuration files: `.json`, `.jsonc`
- Data formats: `.yaml`
- Markup: `.markdown`, `.html`
- Stylesheets: `.css`, `.scss`
- APIs: `.graphql`
- Plus many configuration files (package.json, tsconfig.json, etc.)

### 1.2 System-level Formatters (Arch Linux)

Install system packages for additional language support:

```bash
sudo pacman -S stylua shfmt taplo
```

**Coverage:**
- `stylua` → Lua formatting
- `shfmt` → Shell script formatting
- `taplo` → TOML formatting

**Optional but recommended additions:**

```bash
sudo pacman -S black isort clang-format
```

These provide formatting for Python (`black`, `isort`) and C/C++ (`clang-format`).

## Step 2: Configure Prettier

Create a global Prettier configuration that applies to all projects:

```bash
mkdir -p ~/.config/prettier
```

Then create or edit `~/.config/prettier/.prettierrc.json`:

```json
{
  "semi": true,
  "singleQuote": false,
  "tabWidth": 2,
  "trailingComma": "all"
}
```

Prettier will automatically discover and use this global configuration when formatting files.
