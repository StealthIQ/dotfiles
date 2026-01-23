local options = {
  formatters_by_ft = {
    -- Lua
    lua = { "stylua" },

    -- Web
    css = { "prettier" },
    html = { "prettier" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    javascriptreact = { "prettier" },
    typescriptreact = { "prettier" },

    -- Data / config
    json = { "prettier" },
    jsonc = { "prettier" },
    yaml = { "prettier" },
    markdown = { "prettier" },

    -- Shell
    sh = { "shfmt" },

    -- TOML
    toml = { "taplo" },

    -- Python
    python = { "black" },
  },

  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

return options
