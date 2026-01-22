require "nvchad.options"

-- cursorline
-- vim.opt.cursorlineopt = "both"

-- snacks notifications
vim.schedule(function()
  local ok, snacks = pcall(require, "snacks")
  if ok and snacks.notify then
    local snacks_notify = snacks.notify
    vim.notify = function(msg, level, opts)
      if type(opts) ~= "table" then
        return snacks_notify(msg, level, opts)
      end
      return snacks_notify(msg, {
        title = opts and opts.title,
        level = level,
      })
    end
  end
end)
