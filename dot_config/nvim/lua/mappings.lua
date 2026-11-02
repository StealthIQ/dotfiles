require "nvchad.mappings"

local map = vim.keymap.set

--------------------------------------------------
-- BASIC / MUSCLE MEMORY
--------------------------------------------------

map("n", ";", ":", { desc = "Command mode" })
map("i", "jk", "<ESC>", { desc = "Exit insert mode" })

--------------------------------------------------
-- BETTER VISUAL REPLACE (yours, cleaned)
--------------------------------------------------

map("v", "<leader>r", function()
  local keys = vim.api.nvim_replace_termcodes('"hy:%s/<C-r>h//gc<Left><Left><Left>', true, false, true)
  vim.api.nvim_feedkeys(keys, "n", false)
end, { silent = true, desc = "Replace selection (confirm)" })

-- MARKDOWN PREVIEW
--------------------------------------------------

map("n", "<leader>mv", "<cmd>MarkdownPreviewToggle<CR>", { desc = "Markdown preview toggle" })
map("n", "<leader>me", "<cmd>MarkdownPreview<CR>", { desc = "Markdown preview open" })
map("n", "<leader>md", "<cmd>MarkdownPreviewStop<CR>", { desc = "Markdown preview stop" })

--------------------------------------------------
-- FILE / BUFFER NAVIGATION
--------------------------------------------------

map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit window" })

map("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "Prev buffer" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })

--------------------------------------------------
-- WINDOW MANAGEMENT (FAST SPLITS)
--------------------------------------------------

map("n", "<leader>sv", "<cmd>vsplit<CR>", { desc = "Vertical split" })
map("n", "<leader>sh", "<cmd>split<CR>", { desc = "Horizontal split" })
map("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close split" })

--------------------------------------------------
-- TEXT MOVEMENT (REFINED)
--------------------------------------------------

map("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
map("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move block down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move block up" })

--------------------------------------------------
-- CLEAR SEARCH HIGHLIGHT
--------------------------------------------------

map("n", "<leader>cs", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

--------------------------------------------------
-- LSP (WORKS WITH NVCHAD DEFAULTS)
--------------------------------------------------

map("n", "gr", vim.lsp.buf.references, { desc = "References" })
map("n", "K", vim.lsp.buf.hover, { desc = "Hover docs" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })

--------------------------------------------------
--- Snacks.nvim (Image Preview)
--- ------------------------------------------------
-- IMAGE (snacks.nvim)
map("n", "gh", function()
  require("snacks").image.hover()
end, { desc = "Hover image preview" })

--------------------------------------------------
-- GIT / PICKER / DIAGNOSTICS / IMAGES
--------------------------------------------------

map("n", "<leader>gg", function()
  require("snacks").lazygit()
end, { desc = "Lazygit" })
map("n", "<leader>sf", function()
  require("snacks").picker.files()
end, { desc = "Find files" })
map("n", "<leader>sg", function()
  require("snacks").picker.grep()
end, { desc = "Grep" })
map("n", "<leader>sb", function()
  require("snacks").picker.buffers()
end, { desc = "Buffers" })
map("n", "]d", function()
  vim.diagnostic.jump { count = 1, float = true }
end, { desc = "Next diagnostic" })
map("n", "[d", function()
  vim.diagnostic.jump { count = -1, float = true }
end, { desc = "Prev diagnostic" })
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "<leader>pi", "<cmd>PasteImage<CR>", { desc = "Paste image from clipboard" })
