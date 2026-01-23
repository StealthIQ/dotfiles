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

  -- Markview.nvim (DO NOT lazy load)
  {
    "OXY2DEV/markview.nvim",
    lazy = false,
  },
  -- Copilot
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup {
        panel = {
          enabled = true,
          auto_refresh = true,
          keymap = {
            jump_prev = "[[",
            jump_next = "]]",
            accept = "<CR>",
            refresh = "gr",
            open = "<M-CR>",
          },
          layout = {
            position = "bottom",
            ratio = 0.4,
          },
        },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
          keymap = {
            accept = "<Tab>", -- ONLY Copilot owns Tab
            accept_word = false,
            accept_line = false,
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          },
        },
        filetypes = {
          yaml = true,
          markdown = true,
          help = false,
          gitcommit = false,
          gitrebase = false,
          ["."] = false,
        },
        copilot_node_command = "node",
      }
    end,
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

  {
    "NickvanDyke/opencode.nvim",
    event = "VeryLazy",
    dependencies = {
      { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
    },
    config = function()
      require "configs.opencode"
    end,
  },
}
