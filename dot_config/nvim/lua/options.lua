require "nvchad.options"

-- add yours here!

vim.opt.list = false

-- snacks notifications
-- snacks.nvim automatically overrides vim.notify if notifier is enabled in opts
-- Manual override is usually unnecessary but kept for explicit control if needed
vim.schedule(function()
  local ok, snacks = pcall(require, "snacks")
  if not ok or not snacks.notifier then
    return
  end

  vim.notify = function(msg, level, opts)
    return snacks.notifier.notify(msg, level, opts)
  end
end)
