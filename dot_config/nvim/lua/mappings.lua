require "nvchad.mappings"

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Search and replace using selected text
map("v", "<C-r>", function()
  local keys = vim.api.nvim_replace_termcodes(
    '"hy:%s/<C-r>h//gc<Left><Left><Left>',
    true, false, true
  )
  vim.api.nvim_feedkeys(keys, "n", false)
end, { noremap = true, silent = true, desc = "Replace selected text (global, confirm)" })

-- QoL mappings
map("n", "<leader>cs", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit window" })

-- Keep cursor centered when scrolling
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down centered" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up centered" })
map("n", "n", "nzzzv", { desc = "Next search centered" })
map("n", "N", "Nzzzv", { desc = "Prev search centered" })

-- Copilot accept
map("i", "<C-l>", function()
  if vim.fn["copilot#GetDisplayedSuggestion"]() ~= "" then
    return vim.fn["copilot#Accept"]("")
  end
  return "<C-l>"
end, { expr = true, silent = true, desc = "Accept Copilot suggestion" })
