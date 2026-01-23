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

--------------------------------------------------
-- MARKVIEW (Markdown Preview)
--------------------------------------------------

map("n", "<leader>mv", "<cmd>Markview toggle<CR>", { desc = "Markview toggle" })
map("n", "<leader>ms", "<cmd>Markview splitToggle<CR>", { desc = "Markview split view" })
map("n", "<leader>me", "<cmd>Markview enable<CR>", { desc = "Markview enable" })
map("n", "<leader>md", "<cmd>Markview disable<CR>", { desc = "Markview disable" })

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

map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })

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

map("n", "gd", vim.lsp.buf.definition, { desc = "Goto definition" })
map("n", "gr", vim.lsp.buf.references, { desc = "References" })
map("n", "K", vim.lsp.buf.hover, { desc = "Hover docs" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })

--------------------------------------------------
-- FORMATTING (CONFORM)
--------------------------------------------------

map("n", "<leader>f", function()
  require("conform").format { lsp_fallback = true }
end, { desc = "Format file" })

--------------------------------------------------
--- Snacks.nvim (Image Preview)
--- ------------------------------------------------
-- IMAGE (snacks.nvim)
map("n", "gh", function()
  require("snacks").image.hover()
end, { desc = "Hover image preview" })

map("n", "<leader>oi", function()
  require("snacks").image.hover()
end, { desc = "Open image preview" })

--------------------------------------------------
-- OPENCODE.NVIM
--------------------------------------------------

map({ "n", "x" }, "<leader>oa", function()
  require("opencode").ask("@this: ", { submit = true })
end, { desc = "Opencode Ask (@this)" })

map({ "n", "x" }, "<leader>os", function()
  require("opencode").select()
end, { desc = "Opencode Select Action" })

map({ "n", "t" }, "<leader>ot", function()
  require("opencode").toggle()
end, { desc = "Opencode Toggle" })

map({ "n", "x" }, "<leader>oo", function()
  return require("opencode").operator "@this "
end, { desc = "Opencode Operator", expr = true })

map("n", "<leader>ol", function()
  return require("opencode").operator "@this " .. "_"
end, { desc = "Opencode Line Operator", expr = true })

map("n", "<leader>ou", function()
  require("opencode").command "session.half.page.up"
end, { desc = "Opencode Scroll Up" })

map("n", "<leader>od", function()
  require("opencode").command "session.half.page.down"
end, { desc = "Opencode Scroll Down" })
