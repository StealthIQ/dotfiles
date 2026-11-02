return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = require "configs.conform",
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
    ft = { "markdown" },
    build = "cd app && pnpm install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
      vim.g.mkdp_auto_start = 0
      vim.g.mkdp_auto_close = 1
      vim.g.mkdp_refresh_slow = 0
      vim.g.mkdp_echo_preview_url = 1
      vim.g.mkdp_theme = "dark"
    end,
  },
  {
    "OXY2DEV/markview.nvim",
    ft = { "markdown" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    event = "VeryLazy",
    opts = {
      ensure_installed = {
        "typescript-language-server",
        "html-lsp",
        "css-lsp",
        "json-lsp",
        "yaml-language-server",
        "pyright",
        "prettier",
        "stylua",
        "lua-language-server",
      },
    },
  },
  {
    "HakonHarnes/img-clip.nvim",
    cmd = "PasteImage",
    opts = {},
  },
  -- blink (already present)
  { import = "nvchad.blink.lazyspec" },

  {
    "nvim-tree/nvim-tree.lua",
    opts = {
      filters = {
        dotfiles = false, -- Set to false to show .gitignore and other dotfiles
        git_ignored = false, -- Set to false to show files ignored by git
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "markdown",
        "markdown_inline",
        "yaml",
        "html",
        "css",
        "regex",
        "javascript",
        "typescript",
        "tsx",
        "json",
        "bash",
        "python",
      },
    },
  },
  {
    "folke/snacks.nvim",
    lazy = false, -- image should be available immediately
    priority = 1000,
    opts = {
      image = {
        enabled = true,

        -- you said: no markdown, no inline
        doc = {
          enabled = false,
          inline = false,
          float = true,
        },
      },

      notifier = {
        enabled = true,
      },

      input = {
        enabled = true,
      },
      picker = {
        enabled = true,
      },
      lazygit = {
        enabled = true,
      },
      scope = {
        enabled = true,
      },
      scroll = {
        enabled = true,
      },
      quickfile = {
        enabled = true,
      },
    },
  },

}
